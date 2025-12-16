// backend/routes/userRoutes.js
import express from "express";
import {
  getUserProfile,
  updateUserProfile,
  deleteUser,
  getAllUsers,
} from "../controllers/userController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();

// 👤 Get the logged-in user's profile
router.get("/profile", protect, getUserProfile);

// ✏️ Update user details
router.put("/profile/updateprofile", protect, updateUserProfile);

// ❌ Delete account
router.delete("/delete/user", protect, deleteUser);

// 👥 Admin: Get all users (optional)
router.get("/alluser", protect, getAllUsers);

export default router;
