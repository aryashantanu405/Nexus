import tensorflow as tf
import os

def load_tflite_model(model_path: str):
    if not os.path.exists(model_path):
        raise FileNotFoundError(f"Model not found at {model_path}")

    interpreter = tf.lite.Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    return interpreter


MODELS = {
    "tf1": load_tflite_model("app/ml-models/TF1/tf1_priority_model_optimized.tflite"),
    "tf2": load_tflite_model("app/ml-models/TF2/tf2_focus_model_optimized.tflite"),
    "tf3": load_tflite_model("app/ml-models/TF3/tf3_context_model.tflite"),
    "tf4": load_tflite_model("app/ml-models/TF4/tf4_wellness_model.tflite"),
    "tf5": load_tflite_model("app/ml-models/TF5/tf5_performance_model.tflite"),
}

print("✅ All TFLite models loaded successfully:")
for name in MODELS:
    print(f"   - {name}")
