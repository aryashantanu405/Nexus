import { callGemini } from "./providers/gemini.js";

export const llmResolveIntent = async (text) => {
  const prompt = `
You are an intent classifier.

Return ONLY valid JSON.

Intents:
ADD_TASK (title)
COMPLETE_TASK (taskName)
DELETE_TASK (taskName)
UNKNOWN

User text: "${text}"

Example:
{ "intent": "ADD_TASK", "entities": { "title": "buy milk" } }
`;

  const response = await callGemini(prompt);
  const parsed = JSON.parse(response);

  return {
    intent: parsed.intent || "UNKNOWN",
    entities: parsed.entities || {},
  };
};
