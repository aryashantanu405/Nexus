import UserModel from "../models/userModel.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

/* ================================
   TOKEN GENERATOR
================================ */
const generateTokens = (user) => {
  const accessToken = jwt.sign(
    { id: user._id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: "1h" }
  );

  const refreshToken = jwt.sign(
    { id: user._id },
    process.env.REFRESH_SECRET,
    { expiresIn: "7d" }
  );

  return { accessToken, refreshToken };
};

/* ================================
   REGISTER
================================ */
export const registerUser = async (req, res) => {
  try {
    const { username, name, email, password, phoneNumber } = req.body;

    if (!username || !email || !password) {
      return res
        .status(400)
        .json({ success: false, message: "All fields required" });
    }

    const existing = await UserModel.findOne({ email });
    if (existing) {
      return res
        .status(400)
        .json({ success: false, message: "Email already registered" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await UserModel.create({
      username,
      name,
      email,
      password: hashedPassword,
      phoneNumber,
    });

    const tokens = generateTokens(user);
    user.refreshToken = tokens.refreshToken;
    await user.save();

    user.password = undefined;

    res.status(201).json({
      success: true,
      message: "User registered",
      user,
      tokens,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

/* ================================
   LOGIN
================================ */
export const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await UserModel.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ success: false, message: "Invalid email or password" });
    }

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      return res
        .status(400)
        .json({ success: false, message: "Invalid email or password" });
    }

    const tokens = generateTokens(user);
    user.refreshToken = tokens.refreshToken;
    await user.save();

    user.password = undefined;

    res.status(200).json({
      success: true,
      message: "Login successful",
      user,
      tokens,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

/* ================================
   REFRESH ACCESS TOKEN
   (MATCHES DIO INTERCEPTOR)
================================ */
export const refreshAccessToken = async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return res
        .status(400)
        .json({ success: false, message: "Refresh token required" });
    }

    const refreshToken = authHeader.split(" ")[1];

    const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET);
    const user = await UserModel.findById(decoded.id);

    if (!user || user.refreshToken !== refreshToken) {
      return res
        .status(403)
        .json({ success: false, message: "Invalid refresh token" });
    }

    const tokens = generateTokens(user);
    user.refreshToken = tokens.refreshToken;
    await user.save();

    res.status(200).json({
      success: true,
      message: "Token refreshed",
      accessToken: tokens.accessToken,
    });
  } catch (err) {
    res
      .status(401)
      .json({ success: false, message: "Refresh token expired or invalid" });
  }
};

/* ================================
   GET CURRENT USER
================================ */
export const getCurrentUser = async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return res
        .status(401)
        .json({ success: false, message: "No token provided" });
    }

    const token = authHeader.split(" ")[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const user = await UserModel.findById(decoded.id).select("-password");
    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    res.status(200).json({ success: true, user });
  } catch (err) {
    res.status(401).json({ success: false, message: "Invalid or expired token" });
  }
};

/* ================================
   LOGOUT
================================ */
export const logoutUser = async (req, res) => {
  try {
    const { id } = req.user;
    const user = await UserModel.findById(id);

    if (user) {
      user.refreshToken = null;
      await user.save();
    }

    res.status(200).json({
      success: true,
      message: "Logged out successfully",
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
