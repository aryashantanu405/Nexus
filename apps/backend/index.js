import express from "express";
import http from "http";
import cors from "cors";
import { Server as SocketIOServer } from "socket.io";
import dotenv from "dotenv";

import { dbConnect } from "./utils/dbConnect.js";
import taskRoutes from "./routes/taskRoutes.js";
import mlRoutes from "./routes/mlRoutes.js";
import authRoutes from "./routes/authRoutes.js";
import placeRoutes from "./routes/placeRoutes.js";
//import voiceRoutes from "./routes/voiceRoutes.js";

import {
  findNearbyTasks,
  buildUserSpatialIndex,
} from "./utils/spatialIndex.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());


const port = process.env.PORT || 3000;

// HTTP server
const server = http.createServer(app);

// Socket.IO
const io = new SocketIOServer(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

app.get("/", (req, res) => {
  res.json({
    message: "Nexus Backend is running 🚀",
    status: "OK",
    apis: {
      auth: "/api/auth",
      tasks: "/api/tasks",
      ai: "/api/ai",
      places: "/api/places",
    },
    socket: "Socket.IO enabled",
  });
});

// REST APIs
app.use("/api/tasks", taskRoutes);
app.use("/api/ml", mlRoutes);
app.use("/api/auth",authRoutes);
app.use("/api/places",placeRoutes);
//app.use("/api/voice",voiceRoutes);

// Socket events
io.on("connection", (socket) => {
  console.log("⚡ Client connected:", socket.id);

  socket.on("index:build", async ({ userId }) => {
    try {
      await buildUserSpatialIndex(userId);
      socket.emit("index:built", { success: true });
    } catch (err) {
      socket.emit("index:error", { message: err.message });
    }
  });

  socket.on("location:update", async ({ userId, lat, lng }) => {
    try {
      const matches = await findNearbyTasks(userId, lat, lng);
      socket.emit(
        matches.length > 0 ? "geofence:inside" : "geofence:none",
        { matches }
      );
    } catch (err) {
      socket.emit("geofence:error", { message: err.message });
    }
  });

  socket.on("disconnect", () => {
    console.log("🔌 Client disconnected:", socket.id);
  });
});

// Start server
const startServer = async () => {
  try {
    await dbConnect();
   server.listen(port, "0.0.0.0", () => {
  console.log(`🚀 Server running on http://0.0.0.0:${port}`);
});

  } catch (err) {
    console.error("❌ Startup error:", err.message);
    process.exit(1);
  }
};

startServer();

