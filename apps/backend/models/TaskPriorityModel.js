import mongoose from "mongoose";

const taskPrioritySchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },

    timeUntilDeadline: Number,
    taskDuration: Number,
    taskImportance: Number,

    categoryAcademic: Number,
    categoryWork: Number,
    categoryPersonal: Number,

    userFatigueLevel: Number,
    pastDelayRate: Number,
    urgencyFactor: Number,
    capacityMismatch: Number,

    priorityScore: Number,
  },
  { timestamps: true }
);

export default mongoose.model("TaskPriority", taskPrioritySchema);
