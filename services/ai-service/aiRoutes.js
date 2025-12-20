// routes/aiRoutes.js
import express from "express";
import multer from "multer";
import { 
  chatWithAI, 
  generateImage, 
  speechToText, 
  textToSpeech 
} from "../controllers/aiController.js";

const router = express.Router();
const upload = multer();

router.post("/chat", chatWithAI);
router.post("/image", generateImage);
router.post("/speech-to-text", upload.single("audio"), speechToText);
router.post("/text-to-speech", textToSpeech);

export default router;