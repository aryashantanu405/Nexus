import express from "express";
import dotenv from "dotenv";
import { dbConnect } from "./utils/dbConnect.js";

// --- Import Your New Routes from their folders ---
// THIS IS THE PART YOU'RE MISSING:
//import userRoutes from "./userRoutes.js";
import taskRoutes from "./taskRoutes.js"; // <-- This line defines 'taskRoutes'
//import placeRoutes from "./placeRoutes.js";

// --- Other Imports ---
import { getWeather } from "./utils/getWeather.js";

dotenv.config();
const app = express();
app.use(express.json()); // Middleware to parse JSON

const port = process.env.PORT || 3000;

// --- API ROUTES ---
// Tell Express to use your route files with their base paths
//app.use("/api/users", userRoutes);
app.use("/api/tasks", taskRoutes); // Now this line will work
//app.use("/api/places", placeRoutes);

// --- Weather Test Route ---
// app.get("/weather", async (req, res) => {
//   const { city, lat, lon } = req.query;
//   const weatherData = await getWeather({ city, lat, lon });
//   if (weatherData.error) {
//     return res.status(500).json(weatherData);
//   }
//   return res.json(weatherData);
// });

// --- DATABASE CONNECTION & SERVER START ---
const startServer = async () => {
  try {
    await dbConnect(); // Connects to DB first
    app.listen(port, () => {
      console.log(`Server is listening on port ${port}`);
      console.log(`Try: http://localhost:${port}`);
    });
  } catch (err) {
    console.error("❌ Failed to start server:", err.message);
    process.exit(1);
  }
};

startServer();