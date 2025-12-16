import mongoose from "mongoose";

const focusSessionSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" },

    sessionDuration: Number,
    screenUnlocks: Number,
    appSwitches: Number,
    focusAppRatio: Number,

    notificationCount: Number,
    notificationClickedRatio: Number,
    idleTimeRatio: Number,
    taskProgress: Number,
    breakOverdue: Number,

    focusScore: Number,
    distractionProb: Number,
  },
  { timestamps: true }
);

export default mongoose.model("FocusSession", focusSessionSchema);
