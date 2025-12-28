// import { createTask, deleteTask } from "./taskController.js";
// import {
//   addCurrentPlace,
//   deletePlace,
// } from "./placeController.js";
// import { resolveIntent } from "./aiController.js";

// /**
//  * Utility to call existing controllers programmatically
//  */
// const callController = async (controllerFn, reqData) => {
//   return new Promise((resolve) => {
//     const req = reqData;

//     const res = {
//       status(code) {
//         this.statusCode = code;
//         return this;
//       },
//       json(payload) {
//         resolve({
//           statusCode: this.statusCode || 200,
//           payload,
//         });
//       },
//     };

//     controllerFn(req, res);
//   });
// };

// export const handleVoiceCommand = async (req, res) => {
//   try {
//     const user = req.user;
//     const { text, lat, lng } = req.body;

//     if (!text) {
//       return res.status(400).json({
//         success: false,
//         message: "Voice text is required",
//       });
//     }

//     // 1️⃣ Resolve intent
//     const { intent, entities } = resolveIntent(text);

//     let result;

//     // 2️⃣ Dispatch to EXISTING controllers
//     switch (intent) {
//       case "ADD_TASK":
//         result = await callController(createTask, {
//           user,
//           body: {
//             title: entities.title,
//           },
//         });
//         break;

//       case "DELETE_TASK":
//         return res.status(400).json({
//           success: false,
//           message:
//             "Please specify which task to delete (task id resolution pending)",
//         });

//       case "ADD_PLACE":
//         if (!lat || !lng) {
//           return res.status(400).json({
//             success: false,
//             message: "Location required to add place",
//           });
//         }

//         result = await callController(addCurrentPlace, {
//           user,
//           body: {
//             placeName: entities.placeName,
//             lat,
//             lng,
//             address:entities.placeName,
//           },
//         });
//         break;

//       case "DELETE_PLACE":
//         return res.status(400).json({
//           success: false,
//           message:
//             "Please specify which place to delete (place id resolution pending)",
//         });

//       default:
//         return res.status(400).json({
//           success: false,
//           message: "Sorry, I didn’t understand that command",
//         });
//     }

//     // 3️⃣ Return unified response
//     return res.status(result.statusCode).json({
//       success: true,
//       intent,
//       result: result.payload,
//     });
//   } catch (err) {
//     console.error("Voice command error:", err);
//     return res.status(500).json({
//       success: false,
//       message: "Failed to process voice command",
//     });
//   }
// };
