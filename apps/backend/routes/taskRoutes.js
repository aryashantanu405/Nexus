import express from "express";
import {
  createTask,
  getAllUserTasks,
  getTaskById,
  updateTask,
  deleteTask,
  markTaskComplete,
} from "../controllers/taskController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

/**
 * CREATE TASK
 * POST /api/tasks/createtask
 */
router.post("/createtask", protect, createTask);

/**
 * GET ALL TASKS
 * GET /api/tasks/getalltasks
 * Optional query params: status, priority, limit, offset
 */
router.get("/getalltasks", protect, getAllUserTasks);

/**
 * GET TASK BY ID
 * GET /api/tasks/gettask/:id
 */
router.get("/gettask/:id", protect, getTaskById);

/**
 * UPDATE TASK
 * PUT /api/tasks/updatetask/:id
 */
router.put("/updatetask/:id", protect, updateTask);

/**
 * MARK TASK AS COMPLETED ✅
 * POST /api/tasks/completetask/:id
 */
router.post("/completetask/:id", protect, markTaskComplete);

/**
 * DELETE TASK
 * DELETE /api/tasks/deletetask/:id
 */
router.delete("/deletetask/:id", protect, deleteTask);

export default router;