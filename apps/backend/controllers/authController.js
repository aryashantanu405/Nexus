import UserModel from "../models/userModel.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import dotenv from "dotenv"

dotenv.config();

const generateTokens = (user) => {
  const accessToken = jwt.sign(
    { id: user._id, username: user.username, email: user.email },
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

// 1️⃣ Register
export const registerUser = async (req, res) => {
  try {
    const { username,name, email, password, phoneNumber } = req.body;

    if (!username || !email || !password)
      return res.status(400).json({ success: false, message: "All fields required" });

    const existing = await UserModel.findOne({ email });
    if (existing)
      return res.status(400).json({ success: false, message: "Email already registered" });

    const hashed = await bcrypt.hash(password, 10);
    const user = await UserModel.create({
      username,
      name,
      email,
      password: hashed,
      phoneNumber,
    });

    const tokens = generateTokens(user);
    user.refreshToken = tokens.refreshToken;
    await user.save();

    user.password = undefined;
    res.status(201).json({ success: true, message: "User registered", user, tokens });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// 2️⃣ Login
export const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await UserModel.findOne({ email });
    if (!user)
      return res.status(400).json({ success: false, message: "Invalid email or password" });

    const match = await bcrypt.compare(password, user.password);
    if (!match)
      return res.status(400).json({ success: false, message: "Invalid email or password" });

    const tokens = generateTokens(user);
    user.refreshToken = tokens.refreshToken;
    await user.save();

    user.password = undefined;
    res.status(200).json({ success: true, message: "Login successful", user, tokens });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// 3️⃣ Refresh Token
export const refreshAccessToken = async (req, res) => {
  const { refreshToken } = req.body;
  if (!refreshToken)
    return res.status(400).json({ success: false, message: "Refresh token required" });

  try {
    const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET);
    const user = await UserModel.findById(decoded.id);
    if (!user || user.refreshToken !== refreshToken)
      return res.status(403).json({ success: false, message: "Invalid refresh token" });

    const tokens = generateTokens(user);
    user.refreshToken = tokens.refreshToken;
    await user.save();

    res.status(200).json({ success: true, message: "Token refreshed", tokens });
  } catch (err) {
    res.status(401).json({ success: false, message: "Refresh token expired or invalid" });
  }
};

// Get Profile
export const getCurrentUser = async (req, res) => {
  try{
  
    
    const token = req.headers.authorization?.split(" ")[1];

    const decoded = jwt.decode(token);

    const email = decoded.email;

    const user = await UserModel.findOne({email});

    if (!user)
      return res.status(400).json({ success: false, message: "Invalid email" });

    user.password = undefined;

    res.status(200).json({success: true, user: user});
  }
  catch(err)
  {
    res.status(500).json({success: false, message: err.message});
  }
}

// 4️⃣ Logout
export const logoutUser = async (req, res) => {
  try {
    const { id } = req.user; // extracted via middleware
    const user = await UserModel.findById(id);
    if (user) {
      user.refreshToken = null;
      await user.save();
    }
    res.status(200).json({ success: true, message: "Logged out successfully" });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};
