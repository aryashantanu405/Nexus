import { llmResolveIntent } from "./llmIntent.js";
import { keywordFallback } from "./keywordFallback.js";

/**
 * Resolve user intent from voice text
 * Priority:
 * 1. LLM (only if confident)
 * 2. Keyword fallback (guaranteed)
 */
export const resolveIntent = async (text) => {
  if (!text || typeof text !== "string") {
    return { intent: "UNKNOWN", entities: {} };
  }

  try {
    const llmResult = await llmResolveIntent(text);

    // ✅ Trust LLM ONLY if intent is meaningful
    if (
      llmResult &&
      typeof llmResult === "object" &&
      llmResult.intent &&
      llmResult.intent !== "UNKNOWN"
    ) {
      return {
        intent: llmResult.intent,
        entities: llmResult.entities || {},
      };
    }
  } catch (err) {
    console.error("⚠️ LLM failed, using fallback");
  }

  // ✅ Always fallback if LLM fails or returns UNKNOWN
  return keywordFallback(text);
};
