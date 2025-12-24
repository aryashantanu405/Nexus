import TaskModel from "../models/taskModel.js";

export const findTaskByName = async (userId, taskName) => {
  if (!taskName) return [];

  return await TaskModel.find({
    user: userId,
    title: { $regex: taskName, $options: "i" },
  });
};
