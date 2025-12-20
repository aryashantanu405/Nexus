import mongoose from "mongoose";

const performanceSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },

    taskCompletionRate: Number,
    avgTaskPriority: Number,
    focusScoreAvg: Number,
    distractionProbAvg: Number,
    contextSuccessRate: Number,
    wellnessScore: Number,
    sleepDeviationHours: Number,

    performanceScore: Number,
  },
  { timestamps: true }
);

export default mongoose.model("Performance", performanceSchema);
