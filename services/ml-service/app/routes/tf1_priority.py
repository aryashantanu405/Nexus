from fastapi import APIRouter
from app.schemas.tf1 import TF1PriorityRequest, TF1PriorityResponse
from app.core.registry import MODELS
from app.core.tflite_inference import run_tflite_model

router = APIRouter(
    prefix="/predict/tf1-priority",
    tags=["TF1 - Priority"]
)

@router.post("", response_model=TF1PriorityResponse)
def predict_priority(req: TF1PriorityRequest):
    interpreter = MODELS["tf1"]

    # ⚠️ ORDER MUST MATCH TRAINING
    input_values = [
        req.time_until_deadline,
        req.task_duration,
        req.task_importance,
        req.category_academic,
        req.category_work,
        req.category_personal,
        req.user_fatigue_level,
        req.past_delay_rate,
        req.urgency_factor,
        req.capacity_mismatch
    ]

    score = run_tflite_model(interpreter, input_values)

    return TF1PriorityResponse(priority_score=score)
