import express from "express";
import {
  createTask,
  getAllUserTasks,
  getTaskById,
  updateTask,
  deleteTask,
  markTaskComplete,
} from "./controllers/taskController.js";
import { protect } from "./middleware/authMiddleware.js";

const router = express.Router();

router.post("/createTask", protect, createTask);

router.get("/getAllTasks", protect, getAllUserTasks);

router.get("/getTask/:id", protect, getTaskById);

router.put("/updateTask/:id", protect, updateTask);

router.delete("/deleteTask/:id", protect, deleteTask);

router.post("/completeTask/:id", protect, markTaskComplete);

export default router;