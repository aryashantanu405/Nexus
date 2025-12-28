import TaskPriority from "../models/TaskPriorityModel.js";
import FocusSession from "../models/FocusSessionModel.js";
import Context from "../models/ContextModel.js";
import Wellness from "../models/WellnessModel.js";
import Performance from "../models/PerformanceModel.js";

// TF1
export const taskPriority = async (req, res) => {
  const priorityScore = Math.random(); // placeholder

  const data = await TaskPriority.create({
    ...req.body,
    priorityScore,
  });

  res.json(data);
};

// TF2
export const focusAnalysis = async (req, res) => {
  const focusScore = Math.random();
  const distractionProb = 1 - focusScore;

  const data = await FocusSession.create({
    ...req.body,
    focusScore,
    distractionProb,
  });

  res.json(data);
};

// TF3
export const contextScore = async (req, res) => {
  const contextScore = Math.random();

  const data = await Context.create({
    ...req.body,
    contextScore,
  });

  res.json(data);
};

// TF4
export const wellnessScore = async (req, res) => {
  const wellnessScore = Math.random();

  const data = await Wellness.create({
    ...req.body,
    wellnessScore,
  });

  res.json(data);
};

// TF5
export const performanceScore = async (req, res) => {
  const performanceScore = Math.random();

  const data = await Performance.create({
    ...req.body,
    performanceScore,
  });

  res.json(data);
};

// AI Summary Dashboard
export const userAISummary = async (req, res) => {
  const { userId } = req.params;

  const summary = {
    priority: await TaskPriority.find({ userId })
      .sort({ createdAt: -1 })
      .limit(1),
    focus: await FocusSession.find({ userId })
      .sort({ createdAt: -1 })
      .limit(1),
    wellness: await Wellness.find({ userId })
      .sort({ createdAt: -1 })
      .limit(1),
    performance: await Performance.find({ userId })
      .sort({ createdAt: -1 })
      .limit(1),
  };

  res.json(summary);
};
