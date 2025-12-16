import express from "express";
import getNearbyTasks from "../utils/getNearByTasks.js";

const router = express.Router();

// TEMP TEST ROUTE
router.get("/nearby-test", async (req, res) => {
  try {
    // 🔹 Test user ID (from the data you pasted)
    const testUserId = "66f000000000000000000001";

    // 🔹 Test coordinates (near Main Market)
    const lat = 25.59415;
    const lng = 85.13765;

    const nearbyPlaces = await getNearbyTasks(testUserId, lat, lng);

    res.json({
      success: true,
      count: nearbyPlaces.length,
      data: nearbyPlaces,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      success: false,
      error: err.message,
    });
  }
});

export default router;
