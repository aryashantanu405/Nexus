import mongoose, { Schema } from "mongoose";
const taskSchema = new Schema(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    title: {
      type: String,
      required: [true, "Task title is required"],
      trim: true,
    },
    description: {
      type: String,
      trim: true,
    },
    category: {
      type: String,
      trim: true,
      default: "Personal",
    },
    dueDate: {
      type: Date,
    },
    priority: {
      type: String,
      enum: ["Low", "Medium", "High"],
      default: "Medium",
    },
    status: {
      type: String,
      enum: ["Pending", "In-Progress", "Completed"],
      default: "Pending",
    },
    location: {
      type: Schema.Types.ObjectId,
      ref: "Place", // This links to our PlaceModel
      required: false,
    },

    // --- NEW FIELDS FROM THE PDF ---
    estimatedDuration: {
      // In minutes, as per API doc
      type: Number,
    },
    tags: {
      type: [String],
      default: [],
    },
    subtasks: [
      {
        title: { type: String, required: true },
        completed: { type: Boolean, default: false },
      },
    ],
  },
  {
    timestamps: true,
  }
);

const TaskModel = mongoose.model("Task", taskSchema);

export default TaskModel;