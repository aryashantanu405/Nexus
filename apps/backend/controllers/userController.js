import TaskModel from "../models/taskModel.js";
import PlaceModel from "../models/placeModel.js";
import UserModel from "../models/userModel.js";
import mongoose from "mongoose";
import { limitUserEntries } from "../utils/limitUserEntries.js";

/**
 * =========================
 * CREATE TASK
 * =========================
 */
export const createTask = async (req, res) => {
  console.log("🚀 createTask controller HIT");
  console.log("📦 req.body =", req.body);
  console.log("👤 req.user =", req.user);

  const {
    title,
    description,
    priority,
    dueDate,
    estimatedDuration,
    category,
    tags,
    linkedLocation,
    subtasks,
  } = req.body;
  const parsedDueDate = dueDate ? new Date(dueDate) : null;

  const userId = req.user?.id || req.user?._id;
  console.log("👤 userId =", userId);

  if (!title) {
    return res.status(400).json({
      success: false,
      error: { code: "VALIDATION_ERROR", message: "Title is required." },
    });
  }

  try {
    let placeId = null;

    /**
     * Handle linked location
     */
    if (linkedLocation?.lat && linkedLocation?.lng) {
      const place = await PlaceModel.create({
        user: userId,
        name: linkedLocation.name || "Task Location",
        location: {
          type: "Point",
          coordinates: [linkedLocation.lng, linkedLocation.lat],
        },
        geofenceRadiusMeters: linkedLocation.radius || 100,
      });

      placeId = place._id;

      await UserModel.findByIdAndUpdate(userId, {
        $push: { savedPlaces: place._id },
      });

      limitUserEntries(PlaceModel, userId, 20).catch(() => {});
    }

    /**
     * Create task
     */
    const task = await TaskModel.create({
      user: userId,
      title,
      description,
      priority,
      dueDate: parsedDueDate,
      estimatedDuration,
      category,
      tags,
      subtasks: subtasks || [],
      location: placeId,
      status: "Pending",
    });

    await UserModel.findByIdAndUpdate(userId, {
      $push: { tasks: task._id },
    });

    limitUserEntries(TaskModel, userId, 20).catch(() => {});

    return res.status(201).json({
      success: true,
      data: {
        id: task._id,
        title: task.title,
        status: task.status.toLowerCase(),
        createdAt: task.createdAt,
      },
    });
  } catch (err) {
    console.error("❌ createTask ERROR:", err);
    return res.status(500).json({
      success: false,
      error: { message: err.message },
    });
  }
};

export const getUserProfile = async (req, res) => {
  try {
    const user = await UserModel.findById(req.user._id)
      .populate("tasks", "title status dueDate")
      .populate("savedPlaces", "name address");
    if (!user) return res.status(404).json({ success: false, message: "User not found" });

    res.status(200).json({ success: true, user });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

export const updateUserProfile = async (req, res) => {
  try {
    const updates = req.body;

    const user = await UserModel.findByIdAndUpdate(req.user._id, updates, {
      new: true,
      runValidators: true,
    }).select("-password");

    if (!user) return res.status(404).json({ success: false, message: "User not found" });

    res.status(200).json({ success: true, message: "Profile updated successfully", user });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

export const getAllUsers = async (req, res) => {
  try {
    const users = await UserModel.find().select("-password");
    res.status(200).json({ success: true, count: users.length, users });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

/**
 * =========================
 * GET ALL USER TASKS
 * =========================
 */
export const getAllUserTasks = async (req, res) => {
  try {
    const tasks = await TaskModel.find({
      user: req.user?.id || req.user?._id,
    })
      .sort({ createdAt: -1 })
      .populate("location");

    return res.status(200).json({
      success: true,
      data: tasks.map(t => ({
        id: t._id,
        title: t.title,
        status: t.status.toLowerCase(),
        priority: t.priority,
        dueDate: t.dueDate,
        createdAt: t.createdAt,
      })),
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      error: { message: err.message },
    });
  }
};

/**
 * =========================
 * GET TASK BY ID
 * =========================
 */
export const getTaskById = async (req, res) => {
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return res.status(400).json({
      success: false,
      error: { message: "Invalid Task ID" },
    });
  }

  const task = await TaskModel.findById(req.params.id).populate("location");

  if (!task || task.user.toString() !== (req.user.id || req.user._id)) {
    return res.status(404).json({
      success: false,
      error: { message: "Task not found" },
    });
  }

  return res.status(200).json({
    success: true,
    data: task,
  });
};

/**
 * =========================
 * UPDATE TASK
 * =========================
 */
export const updateTask = async (req, res) => {
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return res.status(400).json({
      success: false,
      error: { message: "Invalid Task ID" },
    });
  }

  const task = await TaskModel.findById(req.params.id);

  if (!task || task.user.toString() !== (req.user.id || req.user._id)) {
    return res.status(404).json({
      success: false,
      error: { message: "Task not found" },
    });
  }

  Object.assign(task, req.body);
  await task.save();

  return res.status(200).json({
    success: true,
    data: {
      id: task._id,
      updatedAt: task.updatedAt,
    },
  });
};

/**
 * =========================
 * MARK TASK COMPLETE
 * =========================
 */
export const markTaskComplete = async (req, res) => {
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return res.status(400).json({
      success: false,
      error: { message: "Invalid Task ID" },
    });
  }

  const task = await TaskModel.findById(req.params.id);

  if (!task || task.user.toString() !== (req.user.id || req.user._id)) {
    return res.status(404).json({
      success: false,
      error: { message: "Task not found" },
    });
  }

  task.status = "Completed";
  await task.save();

  return res.status(200).json({
    success: true,
    data: {
      id: task._id,
      status: task.status.toLowerCase(),
    },
  });
};

/**
 * =========================
 * DELETE TASK
 * =========================
 */
export const deleteTask = async (req, res) => {
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return res.status(400).json({
      success: false,
      error: { message: "Invalid Task ID" },
    });
  }

  const task = await TaskModel.findById(req.params.id);

  if (!task || task.user.toString() !== (req.user.id || req.user._id)) {
    return res.status(404).json({
      success: false,
      error: { message: "Task not found" },
    });
  }

  await UserModel.findByIdAndUpdate(task.user, {
    $pull: { tasks: task._id },
  });

  await TaskModel.deleteOne({ _id: task._id });

  return res.status(200).json({
    success: true,
    message: "Task deleted successfully",
  });
};
  
export const deleteUser = async (req, res) => {
  try {
    await UserModel.findByIdAndDelete(req.user._id);
    res.status(200).json({ success: true, message: "User deleted successfully" });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};