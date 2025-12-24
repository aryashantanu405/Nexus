export const keywordFallback = (text) => {
  const t = text.toLowerCase();

  // ADD TASK
  if (t.includes("add") && t.includes("task")) {
    return {
      intent: "ADD_TASK",
      entities: {
        title: clean(t, ["add", "task", "to", "me", "please"]),
      },
    };
  }

  // COMPLETE TASK
  if (
    t.includes("complete") ||
    t.includes("done") ||
    t.includes("finish")
  ) {
    return {
      intent: "COMPLETE_TASK",
      entities: {
        taskName: clean(t, [
          "complete",
          "done",
          "finish",
          "task",
          "mark",
          "as",
        ]),
      },
    };
  }

  // DELETE TASK
  if (
    t.includes("delete") ||
    t.includes("remove")
  ) {
    return {
      intent: "DELETE_TASK",
      entities: {
        taskName: clean(t, ["delete", "remove", "task"]),
      },
    };
  }

  return { intent: "UNKNOWN", entities: {} };
};

const clean = (text, words) => {
  let result = text;
  words.forEach(w => {
    result = result.replace(new RegExp(`\\b${w}\\b`, "g"), "");
  });
  return result.trim();
};
