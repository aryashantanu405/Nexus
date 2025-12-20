from fastapi import APIRouter
from app.schemas.tf4 import TF4WellnessRequest, TF4WellnessResponse
from app.core.registry import MODELS
from app.core.tflite_inference import run_tflite_model

router = APIRouter(
    prefix="/predict/tf4-wellness",
    tags=["TF4 - Wellness"]
)

@router.post("", response_model=TF4WellnessResponse)
def predict_wellness(req: TF4WellnessRequest):
    interpreter = MODELS["tf4"]

    input_values = [
        req.task_priority_avg,
        req.focus_score_avg,
        req.screen_time_hours,
        req.mood_score
    ]

    score = run_tflite_model(interpreter, input_values)

    return TF4WellnessResponse(wellness_score=score)
