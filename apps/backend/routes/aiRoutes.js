import express from "express";
import * as aiController from "../controllers/aiController.js";

const router = express.Router();

router.post("/task-priority", aiController.taskPriority);
router.post("/focus", aiController.focusAnalysis);
router.post("/context", aiController.contextScore);
router.post("/wellness", aiController.wellnessScore);
router.post("/performance", aiController.performanceScore);

router.get("/summary/:userId", aiController.userAISummary);

export default router;
