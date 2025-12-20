import numpy as np

def run_tflite_model(interpreter, input_values):
    """
    Runs inference on a TFLite model.

    interpreter: tf.lite.Interpreter
    input_values: list[float] in correct order
    """

    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    # Convert input to numpy array
    input_array = np.array([input_values], dtype=np.float32)

    # Set input tensor
    interpreter.set_tensor(input_details[0]["index"], input_array)

    # Run inference
    interpreter.invoke()

    # Get output
    output = interpreter.get_tensor(output_details[0]["index"])

    return float(output[0][0])
