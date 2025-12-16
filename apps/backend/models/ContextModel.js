import mongoose from "mongoose";

const contextSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },

    weatherRisk: Number,
    trafficDelay: Number,
    taskImportance: Number,
    distanceToLocation: Number,
    batteryLevel: Number,

    contextScore: Number,
  },
  { timestamps: true }
);

export default mongoose.model("Context", contextSchema);
