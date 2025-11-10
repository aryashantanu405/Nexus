import jwt from "jsonwebtoken";
import UserModel from "../models/userModel.js";

/**
 * @desc    This middleware protects routes.
 * It checks for a JWT token in the 'Authorization' header.
 * If valid, it attaches the user's data to req.user.
 */
export const protect = async (req, res, next) => {
  let token;

  // Check for 'Authorization' header, starting with 'Bearer'
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    try {
      // 1. Get token from header (e.g., "Bearer <token>")
      token = req.headers.authorization.split(" ")[1];

      // 2. Verify the token's signature
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // 3. Get user from the token's ID
      // We attach this user object to the request
      // so all our controllers can access 'req.user'
      req.user = await UserModel.findById(decoded.id).select("-password");

      if (!req.user) {
         // This check handles if a user was deleted after their token was issued
         return res.status(401).json({ 
            success: false, 
            error: { code: "UNAUTHORIZED", message: "Not authorized, user not found." }
         });
      }

      // 4. Move on to the next function (the controller)
      next(); 
    } catch (error) {
      console.error(error);
      res.status(401).json({ 
        success: false, 
        error: { code: "UNAUTHORIZED", message: "Not authorized, token failed." }
      });
    }
  }

  // 5. If no token was found at all
  if (!token) {
    res.status(401).json({ 
      success: false, 
      error: { code: "UNAUTHORIZED", message: "Not authorized, no token." }
    });
  }
};