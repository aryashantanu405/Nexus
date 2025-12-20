from fastapi import APIRouter
from app.schemas.tf3 import TF3ContextRequest, TF3ContextResponse
from app.core.registry import MODELS
from app.core.tflite_inference import run_tflite_model

router = APIRouter(
    prefix="/predict/tf3-context",
    tags=["TF3 - Context Awareness"]
)

@router.post("", response_model=TF3ContextResponse)
def predict_context(req: TF3ContextRequest):
    interpreter = MODELS["tf3"]

    # ORDER MATTERS — must match training
    input_values = [
        req.weather_risk,
        req.traffic_delay,
        req.task_importance,
        req.distance_to_location,
        req.battery_level
    ]

    score = run_tflite_model(interpreter, input_values)

    return TF3ContextResponse(context_score=score)
