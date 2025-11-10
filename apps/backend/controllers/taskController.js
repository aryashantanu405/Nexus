import TaskModel from "../models/taskModel.js";
import PlaceModel from "../models/placeModel.js";
import UserModel from "../models/userModel.js";
import mongoose from "mongoose";

export const createTask = async (req, res) => {
  const {
    title,
    description,
    priority,
    dueDate,
    estimatedDuration,
    category,
    tags,
    linkedLocation, // This is the object from the PDF
    subtasks,
  } = req.body;

  // req.user.id comes from the 'protect' middleware
  const userId = req.user.id; 

  if (!title) {
    // As per PDF, validation errors are 400
    return res.status(400).json({
      success: false,
      error: {
        code: "VALIDATION_ERROR",
        message: "Title is required.",
      },
    });
  }

  try {
    let placeId = null;

    // --- Handle Linked Location ---
    // If a linkedLocation object is provided, create a new Place
    if (linkedLocation && linkedLocation.lat && linkedLocation.lng) {
      const newPlace = new PlaceModel({
        user: userId,
        name: linkedLocation.name || "Task Location",
        location: {
          type: "Point",
          coordinates: [linkedLocation.lng, linkedLocation.lat], // [long, lat]
        },
        geofenceRadiusMeters: linkedLocation.radius || 100,
      });
      const savedPlace = await newPlace.save();
      placeId = savedPlace._id;

      // Also add this new place to the user's savedPlaces array
      await UserModel.findByIdAndUpdate(userId, {
        $push: { savedPlaces: savedPlace._id },
      });
    }
    // --- End Location Handling ---

    const task = new TaskModel({
      user: userId,
      title,
      description,
      priority,
      dueDate,
      estimatedDuration,
      category,
      tags,
      subtasks: subtasks || [],
      location: placeId, // Assign the new placeId (or null)
      status: "Pending", // Default status on creation
    });

    const createdTask = await task.save();

    // Add task to user's 'tasks' array
    await UserModel.findByIdAndUpdate(userId, {
      $push: { tasks: createdTask._id },
    });

    // Send back the simple response as per the PDF (Page 9)
    res.status(201).json({
      success: true,
      data: {
        id: createdTask._id, // Use _id from MongoDB
        title: createdTask.title,
        status: createdTask.status.toLowerCase(), // 'Pending' -> 'pending'
        createdAt: createdTask.createdAt,
      },
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      error: {
        code: "INTERNAL_ERROR",
        message: "Server error while creating task.",
        details: err.message,
      },
    });
  }
};

export const getAllUserTasks = async (req, res) => {
  try {
    // --- 1. Build Query Object ---
    const query = {
      user: req.user.id,
    };

    if (req.query.status && req.query.status !== "all") {
      const status =
        req.query.status.charAt(0).toUpperCase() + req.query.status.slice(1);
      if (["Pending", "In-Progress", "Completed"].includes(status)) {
        query.status = status;
      }
    }

    if (req.query.priority && req.query.priority !== "all") {
      const priority =
        req.query.priority.charAt(0).toUpperCase() +
        req.query.priority.slice(1);
      if (["Low", "Medium", "High"].includes(priority)) {
        query.priority = priority;
      }
    }

    if (req.query.date) {
      const startDate = new Date(req.query.date);
      const endDate = new Date(req.query.date);
      endDate.setDate(endDate.getDate() + 1);
      query.dueDate = { $gte: startDate, $lt: endDate };
    }

    // --- 2. Pagination ---
    const limit = parseInt(req.query.limit, 10) || 50;
    const offset = parseInt(req.query.offset, 10) || 0;

    // --- 3. Execute Query ---
    const tasks = await TaskModel.find(query)
      .sort({ createdAt: -1 })
      .skip(offset)
      .limit(limit)
      .populate("location"); // Get linked Place details

    const total = await TaskModel.countDocuments(query);

    // --- 4. Format Response (as per PDF) ---
    const formattedTasks = tasks.map((task) => ({
      id: task._id,
      title: task.title,
      description: task.description,
      status: task.status.toLowerCase(),
      priority: task.priority.toLowerCase(),
      dueDate: task.dueDate,
      estimatedDuration: task.estimatedDuration,
      category: task.category,
      tags: task.tags,
      // aiPriorityScore: 9.2, // Stub for later
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    }));

    res.status(200).json({
      success: true,
      data: {
        tasks: formattedTasks,
      },
      pagination: {
        total: total,
        limit: limit,
        offset: offset,
        hasMore: offset + tasks.length < total,
      },
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      error: {
        code: "INTERNAL_ERROR",
        message: "Server error fetching tasks.",
        details: err.message,
      },
    });
  }
};

export const getTaskById = async (req, res) => {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({
        success: false,
        error: { code: "VALIDATION_ERROR", message: "Invalid Task ID." },
      });
    }

    const task = await TaskModel.findById(req.params.id).populate("location");

    // --- Security Check ---
    if (!task) {
      return res.status(404).json({
        success: false,
        error: { code: "NOT_FOUND", message: "Task not found." },
      });
    }

    if (task.user.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        error: { code: "FORBIDDEN", message: "Not authorized to access this task." },
      });
    }

    // --- Format Response (as per PDF) ---
    const formattedTask = {
      id: task._id,
      title: task.title,
      description: task.description,
      status: task.status.toLowerCase(),
      priority: task.priority.toLowerCase(),
      dueDate: task.dueDate,
      estimatedDuration: task.estimatedDuration,
      category: task.category,
      tags: task.tags,
      subtasks: task.subtasks.map(sub => ({
        id: sub._id, // subtasks get an _id
        title: sub.title,
        completed: sub.completed,
      })),
      // aiPriorityScore: 9.2, // Stub for later
      // aiSuggestedTime: "2025-11-12T14:00:00Z", // Stub for later
      linkedLocation: task.location
        ? {
            name: task.location.name,
            lat: task.location.location.coordinates[1], // lat
            lng: task.location.location.coordinates[0], // long
            radius: task.location.geofenceRadiusMeters,
          }
        : null,
      // reminders: [], // Stub for later
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    };

    res.status(200).json({
      success: true,
      data: formattedTask,
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      error: {
        code: "INTERNAL_ERROR",
        message: "Server error fetching task.",
        details: err.message,
      },
    });
  }
};

export const updateTask = async (req, res) => {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({
        success: false,
        error: { code: "VALIDATION_ERROR", message: "Invalid Task ID." },
      });
    }

    let task = await TaskModel.findById(req.params.id);

    // --- Security Check ---
    if (!task) {
      return res.status(404).json({
        success: false,
        error: { code: "NOT_FOUND", message: "Task not found." },
      });
    }

    if (task.user.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        error: { code: "FORBIDDEN", message: "Not authorized to update this task." },
      });
    }

    // --- Update Fields ---
    // We only update fields that are sent in the body
    const {
      title,
      description,
      priority,
      dueDate,
      estimatedDuration,
      category,
      tags,
      subtasks,
      status, // e.g., "in_progress" from PDF
    } = req.body;

    if (title) task.title = title;
    if (description) task.description = description;
    if (priority) task.priority = priority.charAt(0).toUpperCase() + priority.slice(1);
    if (dueDate) task.dueDate = dueDate;
    if (estimatedDuration) task.estimatedDuration = estimatedDuration;
    if (category) task.category = category;
    if (tags) task.tags = tags;
    if (subtasks) task.subtasks = subtasks;
    if (status) task.status = status.charAt(0).toUpperCase() + status.slice(1);

    const updatedTask = await task.save();

    // --- Format Response (as per PDF) ---
    res.status(200).json({
      success: true,
      data: {
        id: updatedTask._id,
        title: updatedTask.title,
        priority: updatedTask.priority.toLowerCase(),
        status: updatedTask.status.toLowerCase(),
        updatedAt: updatedTask.updatedAt,
      },
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      error: {
        code: "INTERNAL_ERROR",
        message: "Server error updating task.",
        details: err.message,
      },
    });
  }
};

export const deleteTask = async (req, res) => {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({
        success: false,
        error: { code: "VALIDATION_ERROR", message: "Invalid Task ID." },
      });
    }

    const task = await TaskModel.findById(req.params.id);

    // --- Security Check ---
    if (!task) {
      return res.status(404).json({
        success: false,
        error: { code: "NOT_FOUND", message: "Task not found." },
      });
    }

    if (task.user.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        error: { code: "FORBIDDEN", message: "Not authorized to delete this task." },
      });
    }

    // --- Perform Delete ---
    
    // 1. Remove task from user's 'tasks' array
    await UserModel.findByIdAndUpdate(task.user, {
      $pull: { tasks: task._id },
    });
    
    // 2. If task had a linked location, (optionally) delete it
    // We'll leave the Place for now, as other tasks might use it.
    // If you wanted to delete it:
    // if (task.location) {
    //   await PlaceModel.findByIdAndDelete(task.location);
    //   await UserModel.findByIdAndUpdate(task.user, {
    //     $pull: { savedPlaces: task.location },
    //   });
    // }

    // 3. Delete the task itself
    await TaskModel.deleteOne({ _id: task._id });

    // --- Format Response (as per PDF) ---
    res.status(200).json({
      success: true,
      message: "Task deleted successfully",
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      error: {
        code: "INTERNAL_ERROR",
        message: "Server error deleting task.",
        details: err.message,
      },
    });
  }
};

export const markTaskComplete = async (req, res) => {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
      return res.status(400).json({
        success: false,
        error: { code: "VALIDATION_ERROR", message: "Invalid Task ID." },
      });
    }

    const { completedAt, notes } = req.body;
    let task = await TaskModel.findById(req.params.id);

    // --- Security Check ---
    if (!task) {
      return res.status(404).json({
        success: false,
        error: { code: "NOT_FOUND", message: "Task not found." },
      });
    }

    if (task.user.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        error: { code: "FORBIDDEN", message: "Not authorized to complete this task." },
      });
    }

    // --- Update Status ---
    task.status = "Completed";
    const completedTimestamp = completedAt ? new Date(completedAt) : new Date();
    // You could save the 'notes' to a new field if you add it to the model
    // e.g., task.completionNotes = notes;

    const updatedTask = await task.save();

    // --- Format Response (as per PDF) ---
    res.status(200).json({
      success: true,
      data: {
        id: updatedTask._id,
        status: updatedTask.status.toLowerCase(),
        completedAt: completedTimestamp, // Send back the completion time
      },
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      error: {
        code: "INTERNAL_ERROR",
        message: "Server error completing task.",
        details: err.message,
      },
    });
  }
};