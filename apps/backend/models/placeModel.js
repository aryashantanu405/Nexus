import mongoose, { Schema } from "mongoose";
// No longer need 'Decimal128' from 'mongodb'

const placeSchema = new Schema(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    name: {
      // e.g., "Home", "Work", "Main Supermarket"
      type: String,
      required: true,
      trim: true,
    },
    address: {
      type: String,
      trim: true,
      required: false,
    },

    // --- THIS IS THE CORRECTED GEOJSON FIELD ---
    // I've renamed 'linkedLocation' back to 'location' to match your index
    location: {
      type: {
        type: String,
        enum: ["Point"], // Must be 'Point' for GeoJSON
        default: "Point",
        required: true,
      },
      coordinates: {
        type: [Number], // Must be in [longitude, latitude] order
        required: true,
      },
    },

    geofenceRadiusMeters: {
      type: Number,
      default: 50, 
    },
    subTasks: {
      type: [String],
      default: [],
    },
  },
  {
    timestamps: true,
  }
);

// --- CRITICAL ---
// This line now works, because we have a field named "location"
// that uses the correct GeoJSON format.
placeSchema.index({ location: "2dsphere" });

const PlaceModel = mongoose.model("Place", placeSchema);

export default PlaceModel;