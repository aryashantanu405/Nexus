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

router.post("/createtask", protect, createTask);

router.get("/getalltasks", protect, getAllUserTasks);

router.get("/gettask/:id", protect, getTaskById);

router.put("/updatetask/:id", protect, updateTask);

router.delete("/deletetask/:id", protect, deleteTask);

router.post("/completetask/:id", protect, markTaskComplete);

export default router;