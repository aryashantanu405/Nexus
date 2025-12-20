import PlaceModel from "../models/placeModel.js";
import { dbConnect } from "./dbConnect.js";
import mongoose from "mongoose";
/**
 * Finds nearby places for a user based on current location
 *
 * @param {String} userId - MongoDB ObjectId of the user
 * @param {Number} lat - current latitude
 * @param {Number} lng - current longitude
 * @returns {Array} list of nearby places with distance
 */
const getNearbyPlaces = async (userId, lat, lng) => {
  // 1️⃣ Ensure database connection
  await dbConnect();

  // MongoDB GeoJSON requires [longitude, latitude]
  const userCoordinates = [lng, lat];

  const nearbyPlaces = await PlaceModel.aggregate([
    {
      $geoNear: {
        near: {
          type: "Point",
          coordinates: userCoordinates,
        },
        distanceField: "distanceMeters",
        spherical: true,
        query: {
          user: new mongoose.Types.ObjectId(userId),
        },
      },
    },
    {
      $match: {
        $expr: {
          $lte: ["$distanceMeters", "$geofenceRadiusMeters"],
        },
      },
    },
    {
      $project: {
        name: 1,
        address: 1,
        subTasks: 1,
        geofenceRadiusMeters: 1,
        distanceMeters: { $round: ["$distanceMeters", 0] },
      },
    },
  ]);

  return nearbyPlaces;
};

export default getNearbyPlaces;
