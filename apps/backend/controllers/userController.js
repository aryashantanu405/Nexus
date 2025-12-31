// backend/controllers/userController.js
import UserModel from "../models/userModel.js";

/**
 * 🧩 Get user profile (Protected)
 */
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

/**
 * 📝 Update user profile (Protected)
 */
export const updateUserProfile = async (req, res) => {
  try {
    const updates = req.body;

    if(!updates.password)
    {
      delete updates.password;
    }

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

/**
 * ❌ Delete user account (Protected)
 */
export const deleteUser = async (req, res) => {
  try {
    await UserModel.findByIdAndDelete(req.user._id);
    res.status(200).json({ success: true, message: "User deleted successfully" });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

/**
 * 👥 Get all users (Admin only, optional)
 */
// export const getAllUsers = async (req, res) => {
//   try {
//     const users = await UserModel.find().select("-password");
//     res.status(200).json({ success: true, count: users.length, users });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// };

/**
 * 👥 Get all users (Admin only, optional)
 */
export const getAllUsers = async (req, res) => {
  try {
    const users = await UserModel.find().select("-password");
    res.status(200).json({ success: true, count: users.length, users });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};