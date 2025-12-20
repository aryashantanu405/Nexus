import express from "express";
import http from "http";
import { Server as SocketIOServer } from "socket.io";
import dotenv from "dotenv";

import { dbConnect } from "./utils/dbConnect.js";
import taskRoutes from "./routes/taskRoutes.js";
import aiRoutes from "./routes/aiRoutes.js";
import authRoutes from "./routes/authRoutes.js";

import {
  findNearbyTasks,
  buildUserSpatialIndex,
} from "./utils/spatialIndex.js";

dotenv.config();

const app = express();
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

// REST APIs
app.use("/api/tasks", taskRoutes);
app.use("/api/ai", aiRoutes);
app.use("/api/auth",authRoutes);

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
    server.listen(port, () => {
      console.log(`🚀 Server running on http://localhost:${port}`);
    });
  } catch (err) {
    console.error("❌ Startup error:", err.message);
    process.exit(1);
  }
};

startServer();
