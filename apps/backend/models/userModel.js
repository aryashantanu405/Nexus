import mongoose, { Schema } from "mongoose";

const userSchema = new Schema(
  {
    username: {
      type: String,
      required: [true, "Username is required"],
      unique: true,
      lowercase: true,
      trim: true,
      index: true, // Good for performance
    },
    name: {
      type: String,
      required: false,
      lowercase: true,
      trim: true,
      default: "User",
    },
    email: {
      type: String,
      required: [true, "Email is required"],
      unique: true,
      lowercase: true,
      trim: true,
    },
    password: {
      type: String,
      required: [true, "Password is required"],
      // Note: You must hash this password before saving!
    },
    phoneNumber: {
      type: String,
      trim: true,
      sparse: true, // Allows multiple nulls, but unique if provided
    },

    // 👇👇 ADD THIS FIELD (for JWT refresh tokens)
    refreshToken: {
      type: String,
      default: null,
    },

    // --- Relationships ---
    tasks: [
      {
        type: Schema.Types.ObjectId,
        ref: "Task", // Points to the 'Task' model
      },
    ],
    savedPlaces: [
      {
        type: Schema.Types.ObjectId,
        ref: "Place", // Points to the 'Place' model
      },
    ],

    // --- Pillar 3: The Proactive Coach ---
    preferences: {
      focusMode: {
        type: Boolean,
        default: false,
      },
      wellnessGoals: {
        type: [String],
        default: [],
      },
    },

    // --- Pillar 4: The Reflective Partner ---
    socialMemory: [
      {
        name: String,
        relationship: String,
        birthday: Date,
        lastContact: Date,
      },
    ],
    journalEntries: [
      {
        content: String,
        date: { type: Date, default: Date.now },
        mood: { type: String, enum: ["Happy", "Neutral", "Sad", "Stressed"] },
      },
    ],
  },
  {
    timestamps: true, // Adds createdAt, updatedAt automatically
  }
);

const UserModel = mongoose.model("User", userSchema);

export default UserModel;
