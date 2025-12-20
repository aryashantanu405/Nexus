// controllers/aiController.js
import { openai } from "../config/aiClient.js";

export const chatWithAI = async (req, res) => {
  try {
    const { prompt } = req.body;

    const response = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: prompt }],
    });

    res.json({ reply: response.choices[0].message.content });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const generateImage = async (req, res) => {
  try {
    const { prompt } = req.body;

    const response = await openai.images.generate({
      model: "gpt-image-1",
      prompt,
      size: "512x512"
    });

    res.json({ image: response.data[0].url });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const speechToText = async (req, res) => {
  try {
    const file = req.file;

    const result = await openai.audio.transcriptions.create({
      file,
      model: "gpt-4o-mini-tts"
    });

    res.json({ text: result.text });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const textToSpeech = async (req, res) => {
  try {
    const { text } = req.body;

    const result = await openai.audio.speech.create({
      model: "gpt-4o-mini-tts",
      voice: "alloy",
      input: text,
    });

    res.setHeader("Content-Type", "audio/mpeg");
    res.send(Buffer.from(await result.arrayBuffer()));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};