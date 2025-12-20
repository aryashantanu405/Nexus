import mongoose from "mongoose";

const wellnessSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },

    taskPriorityAvg: Number,
    focusScoreAvg: Number,
    screenTimeHours: Number,
    moodScore: Number,

    wellnessScore: Number,
  },
  { timestamps: true }
);

export default mongoose.model("Wellness", wellnessSchema);
