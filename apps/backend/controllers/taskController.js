import TaskModel from "../models/taskModel.js";
import PlaceModel from "../models/placeModel.js";
import UserModel from "../models/userModel.js";
import mongoose from "mongoose";
import { limitUserEntries } from "../utils/limitUserEntries.js";

/**
 * CREATE TASK
 */
export const createTask = async (req, res) => {
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

  const parsedDate = dueDate ? new Date(dueDate) : null;

  console.log(parsedDate);
  

  const userId = req.user.id;

  if (!title) {
    return res.status(400).json({
      success: false,
      error: { code: "VALIDATION_ERROR", message: "Title is required." },
    });
  }

  try {
    let placeId = null;

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

      limitUserEntries(PlaceModel, userId, 20).catch(console.error);
    }

    const task = await TaskModel.create({
      user: userId,
      title,
      description,
      priority,
      dueDate: parsedDate,
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

    limitUserEntries(TaskModel, userId, 20).catch(console.error);

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
    return res.status(500).json({
      success: false,
      error: {
        code: "INTERNAL_ERROR",
        message: "Server error while creating task.",
        details: err.message,
      },
    });
  }
};

/**
 * GET ALL TASKS
 */
export const getAllUserTasks = async (req, res) => {
  try {
    const query = { user: req.user.id };

    if (req.query.status && req.query.status !== "all") {
      query.status =
        req.query.status.charAt(0).toUpperCase() +
        req.query.status.slice(1);
    }

    if (req.query.priority && req.query.priority !== "all") {
      query.priority =
        req.query.priority.charAt(0).toUpperCase() +
        req.query.priority.slice(1);
    }

    const limit = Number(req.query.limit) || 50;
    const offset = Number(req.query.offset) || 0;

    const tasks = await TaskModel.find(query)
      .sort({ createdAt: -1 })
      .skip(offset)
      .limit(limit)
      .populate("location");

    const total = await TaskModel.countDocuments(query);

    return res.status(200).json({
      success: true,
      data: {
        tasks: tasks.map(t => ({
          id: t._id,
          title: t.title,
          description: t.description,
          status: t.status.toLowerCase(),
          priority: t.priority.toLowerCase(),
          dueDate: t.dueDate,
          estimatedDuration: t.estimatedDuration,
          category: t.category,
          tags: t.tags,
          createdAt: t.createdAt,
          updatedAt: t.updatedAt,
        })),
      },
      pagination: {
        total,
        limit,
        offset,
        hasMore: offset + tasks.length < total,
      },
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      error: {
        code: "INTERNAL_ERROR",
        message: "Server error fetching tasks.",
        details: err.message,
      },
    });
  }
};

/**
 * GET TASK BY ID
 */
export const getTaskById = async (req, res) => { 
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return res.status(400).json({
      success: false,
      error: { code: "VALIDATION_ERROR", message: "Invalid Task ID." },
    });
  }

  const task = await TaskModel.findById(req.params.id).populate("location");

  if (!task)
    return res.status(404).json({
      success: false,
      error: { code: "NOT_FOUND", message: "Task not found." },
    });

  if (task.user.toString() !== req.user.id)
    return res.status(403).json({
      success: false,
      error: { code: "FORBIDDEN", message: "Not authorized." },
    });

  return res.status(200).json({
    success: true,
    data: task,
  });
};

/**
 * UPDATE TASK ✅ (THIS FIXES YOUR CURRENT ERROR)
 */
export const updateTask = async (req, res) => {
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return res.status(400).json({
      success: false,
      error: { code: "VALIDATION_ERROR", message: "Invalid Task ID." },
    });
  }

  const task = await TaskModel.findById(req.params.id);

  if (!task)
    return res.status(404).json({
      success: false,
      error: { code: "NOT_FOUND", message: "Task not found." },
    });

  if (task.user.toString() !== req.user.id)
    return res.status(403).json({
      success: false,
      error: { code: "FORBIDDEN", message: "Not authorized." },
    });

  Object.assign(task, req.body);
  await task.save();

  return res.status(200).json({
    success: true,
    data: {
      id: task._id,
      status: task.status.toLowerCase(),
      updatedAt: task.updatedAt,
    },
  });
};

/**
 * MARK TASK COMPLETE
 */
export const markTaskComplete = async (req, res) => {
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return res.status(400).json({
      success: false,
      error: { code: "VALIDATION_ERROR", message: "Invalid Task ID." },
    });
  }

  const task = await TaskModel.findById(req.params.id);

  if (!task)
    return res.status(404).json({
      success: false,
      error: { code: "NOT_FOUND", message: "Task not found." },
    });

  if (task.user.toString() !== req.user.id)
    return res.status(403).json({
      success: false,
      error: { code: "FORBIDDEN", message: "Not authorized." },
    });

  task.status = "Completed";
  await task.save();

  return res.status(200).json({
    success: true,
    data: {
      id: task._id,
      status: "completed",
      completedAt: new Date(),
    },
  });
};

/**
 * DELETE TASK
 */
export const deleteTask = async (req, res) => {
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return res.status(400).json({
      success: false,
      error: { code: "VALIDATION_ERROR", message: "Invalid Task ID." },
    });
  }

  const task = await TaskModel.findById(req.params.id);

  if (!task)
    return res.status(404).json({
      success: false,
      error: { code: "NOT_FOUND", message: "Task not found." },
    });

  if (task.user.toString() !== req.user.id)
    return res.status(403).json({
      success: false,
      error: { code: "FORBIDDEN", message: "Not authorized." },
    });

  await UserModel.findByIdAndUpdate(task.user, {
    $pull: { tasks: task._id },
  });

  await TaskModel.deleteOne({ _id: task._id });

  return res.status(200).json({
    success: true,
    message: "Task deleted successfully",
  });
};
