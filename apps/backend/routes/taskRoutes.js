import express from "express";
import {
  createTask,
  getAllUserTasks,
  getTaskById,
  updateTask,
  deleteTask,
  markTaskComplete,
  markTasksCompletedBulk,
} from "../controllers/taskController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

/**
 * CREATE TASK
 * POST /api/tasks
 */
router.post("/createtask", protect, createTask);

/**
 * GET ALL TASKS
 * GET /api/tasks
 */
router.get("/getalltasks", protect, getAllUserTasks);

/**
 * MARK MULTIPLE TASKS AS COMPLETED (BULK) ✅
 * POST /api/tasks/complete
 * Body: { taskIds: [] }
 */
router.post("/complete", protect, markTasksCompletedBulk);

/**
 * MARK SINGLE TASK AS COMPLETED
 * POST /api/tasks/:id/complete
 */
router.post("/:id/complete", protect, markTaskComplete);

/**
 * GET TASK BY ID
 * GET /api/tasks/:id
 */
router.get("/:id", protect, getTaskById);

/**
 * UPDATE TASK
 * PUT /api/tasks/:id
 */
router.put("/:id", protect, updateTask);

/**
 * DELETE TASK
 * DELETE /api/tasks/:id
 */
router.delete("/:id", protect, deleteTask);

export default router;
 