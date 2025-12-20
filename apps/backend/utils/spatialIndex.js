// backend/utils/spatialIndex.js
import TaskModel from "../models/taskModel.js";
import PlaceModel from "../models/placeModel.js";
import UserModel from "../models/userModel.js";

/**
 * Spatial hashing based on fixed-size square cells in meters.
 * Tunable constant: CELL_SIZE_METERS
 *
 * Data structure:
 *  userSpatialIndex = {
 *    [userId]: Map { cellKey => Set(placeObject) }
 *  }
 *
 * placeObject: {
 *   placeId,
 *   taskId,
 *   lat,
 *   lng,
 *   radiusMeters
 * }
 */

const userSpatialIndex = new Map();

// Tune this based on expected geofence sizes and density.
// If typical geofence radius ~100m, set cell size = 100 or 200 for fewer checks.
export const CELL_SIZE_METERS = 200;

/* ---------- Helpers: convert lat/lon to approximate meters and cell key ---------- */

/**
 * Approx meters per degree latitude (approx).
 */
const METERS_PER_DEG_LAT = 111320;

/**
 * Convert degrees longitude to meters at a given latitude.
 */
function metersPerDegLon(lat) {
  return Math.cos((lat * Math.PI) / 180) * 111320;
}

/**
 * Convert lat -> meters (relative to eq). For hashing we use absolute meters.
 */
function latToMeters(lat) {
  return lat * METERS_PER_DEG_LAT;
}

/**
 * Convert lon -> meters at latitude
 */
function lonToMeters(lon, lat) {
  return lon * metersPerDegLon(lat);
}

/**
 * Get integer cell coords (cx, cy) and a key string.
 */
function getCellForLatLng(lat, lng) {
  const mx = lonToMeters(lng, lat);
  const my = latToMeters(lat);
  const cx = Math.floor(mx / CELL_SIZE_METERS);
  const cy = Math.floor(my / CELL_SIZE_METERS);
  return { cx, cy, key: `${cx}:${cy}` };
}

/**
 * For a given radius (m), compute how many cells in each direction must be checked.
 */
function neighborRadiusInCells(radiusMeters) {
  return Math.ceil(radiusMeters / CELL_SIZE_METERS);
}

/**
 * Return list of neighbor cell keys (square) centered on (cx,cy) with radius cells.
 */
function getNeighborCellKeys(cx, cy, radiusCells) {
  const keys = [];
  for (let dx = -radiusCells; dx <= radiusCells; dx++) {
    for (let dy = -radiusCells; dy <= radiusCells; dy++) {
      keys.push(`${cx + dx}:${cy + dy}`);
    }
  }
  return keys;
}

/* ---------- Distance check (Haversine for correctness) ---------- */

function deg2rad(deg) {
  return (deg * Math.PI) / 180;
}

function haversineDistanceMeters(lat1, lon1, lat2, lon2) {
  // returns meters
  const R = 6371000; // Earth radius in meters
  const dLat = deg2rad(lat2 - lat1);
  const dLon = deg2rad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) *
      Math.cos(deg2rad(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

/* ---------- Index operations ---------- */

function ensureUserIndex(userId) {
  if (!userSpatialIndex.has(userId)) {
    userSpatialIndex.set(userId, new Map());
  }
  return userSpatialIndex.get(userId);
}

/**
 * Add a place record into user's spatial index.
 * placeObj: { placeId, taskId, lat, lng, radiusMeters }
 */
export function addPlaceToIndex(userId, placeObj) {
  const idx = ensureUserIndex(userId);
  const { key } = getCellForLatLng(placeObj.lat, placeObj.lng);
  if (!idx.has(key)) idx.set(key, new Set());
  idx.get(key).add(placeObj);
}

/**
 * Remove place from user's index by placeId (and optional taskId).
 */
export function removePlaceFromIndex(userId, placeId, taskId = null) {
  const idx = userSpatialIndex.get(userId);
  if (!idx) return;
  for (const [key, set] of idx.entries()) {
    for (const place of Array.from(set)) {
      if (place.placeId.toString() === placeId.toString() && (taskId == null || place.taskId.toString() === taskId.toString())) {
        set.delete(place);
      }
    }
    if (set.size === 0) idx.delete(key);
  }
}

/**
 * Clear user's entire index (useful when rebuilding)
 */
export function clearUserIndex(userId) {
  userSpatialIndex.delete(userId);
}

/* ---------- Build index from DB (initial load) ---------- */

/**
 * Build spatial index for a given user by fetching all tasks with linked location (Place).
 * This should be called after user login or periodically in background.
 */
export async function buildUserSpatialIndex(userId) {
  // ensure user exists
  const user = await UserModel.findById(userId).exec();
  if (!user) throw new Error("User not found");

  // find tasks for the user that have a linked location (task.location is ObjectId -> Place)
  const tasks = await TaskModel.find({ user: userId, location: { $ne: null } })
    .populate("location")
    .select("_id location")
    .exec();

  // clear old index
  clearUserIndex(userId);
  const idx = ensureUserIndex(userId);

  for (const t of tasks) {
    const place = t.location;
    if (!place || !place.location || !place.location.coordinates) continue;
    const lng = place.location.coordinates[0];
    const lat = place.location.coordinates[1];
    const radiusMeters = place.geofenceRadiusMeters || 100;
    const placeObj = {
      placeId: place._id,
      taskId: t._id,
      lat,
      lng,
      radiusMeters,
    };
    const { key } = getCellForLatLng(lat, lng);
    if (!idx.has(key)) idx.set(key, new Set());
    idx.get(key).add(placeObj);
  }
  return true;
}

/* ---------- Query: findNearbyTasks ---------- */

/**
 * Find tasks (places) for userId whose geofence circle contains the point (lat, lng).
 *
 * @param {String} userId
 * @param {Number} lat
 * @param {Number} lng
 * @param {Number} [radiusMetersToCheck=null] optional extra radius to check for dynamic queries (usually null)
 * @returns Array of matched placeObjs: [{ placeId, taskId, lat, lng, radiusMeters, distanceMeters }]
 */
export async function findNearbyTasks(userId, lat, lng, radiusMetersToCheck = 0) {
  // Ensure index exists; if not, build it on demand (lazy)
  if (!userSpatialIndex.has(userId)) {
    // build lazily
    await buildUserSpatialIndex(userId);
  }

  const idx = userSpatialIndex.get(userId);
  if (!idx) return [];

  // compute target cell and neighbor radius
  const { cx, cy } = getCellForLatLng(lat, lng);
  // We must consider geofence radius of places (they vary). To be safe, we compute neighborCells using 
  // max of (CELL_SIZE_METERS, radiusMetersToCheck) and also allow scanning adjacent cells to catch edge cases.
  const radiusCells = neighborRadiusInCells(Math.max(radiusMetersToCheck, CELL_SIZE_METERS));
  const neighborKeys = getNeighborCellKeys(cx, cy, radiusCells);

  const candidates = [];
  for (const key of neighborKeys) {
    const set = idx.get(key);
    if (!set) continue;
    for (const place of set) {
      // quick bounding-box filter (cheap):
      // compute approximate delta-lat/delta-lon degrees for the place radius + radiusMetersToCheck
      const maxCheckMeters = place.radiusMeters + radiusMetersToCheck;
      // compute approximate lat/lon degree tolerance
      const latTol = maxCheckMeters / METERS_PER_DEG_LAT;
      const lonTol = maxCheckMeters / metersPerDegLon(place.lat);
      if (Math.abs(place.lat - lat) > latTol || Math.abs(place.lng - lng) > lonTol) {
        continue; // skip - too far in bbox approximation
      }
      // accurate distance
      const dist = haversineDistanceMeters(lat, lng, place.lat, place.lng);
      if (dist <= place.radiusMeters + radiusMetersToCheck) {
        candidates.push({ ...place, distanceMeters: dist });
      }
    }
  }

  return candidates;
}

/* ---------- Utility: update index when one task/place changes ---------- */

/**
 * Call when a task with linked location is created/updated.
 * If place exists, adds/updates it in the index.
 */
export async function upsertPlaceForTask(userId, taskId, placeId) {
  if (!placeId) return;
  const place = await PlaceModel.findById(placeId).exec();
  if (!place) return;
  const lng = place.location.coordinates[0];
  const lat = place.location.coordinates[1];
  const radiusMeters = place.geofenceRadiusMeters || 100;
  // remove old entry for same taskId if exists
  removePlaceFromIndex(userId, placeId, taskId);
  addPlaceToIndex(userId, {
    placeId: place._id,
    taskId,
    lat,
    lng,
    radiusMeters,
  });
}

/**
 * Call when a task/place is deleted to remove from index.
 */
export async function removePlaceForTask(userId, taskId, placeId) {
  removePlaceFromIndex(userId, placeId, taskId);
}
import mongoose from "mongoose";