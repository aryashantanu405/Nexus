from fastapi import APIRouter
from app.schemas.tf2 import TF2FocusRequest, TF2FocusResponse
from app.core.registry import MODELS
from app.core.tflite_inference import run_tflite_model

router = APIRouter(
    prefix="/predict/tf2-focus",
    tags=["TF2 - Focus"]
)

@router.post("", response_model=TF2FocusResponse)
def predict_focus(req: TF2FocusRequest):
    interpreter = MODELS["tf2"]

    # ⚠️ ORDER MUST MATCH TRAINING
    input_values = [
        req.session_duration,
        req.screen_unlocks,
        req.app_switches,
        req.focus_app_ratio,
        req.notification_count,
        req.notification_clicked_ratio,
        req.idle_time_ratio,
        req.task_progress,
        req.break_overdue
    ]

    score = run_tflite_model(interpreter, input_values)

    return TF2FocusResponse(focus_score=score)
