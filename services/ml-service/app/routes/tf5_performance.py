from fastapi import APIRouter
from app.schemas.tf5 import TF5PerformanceRequest, TF5PerformanceResponse
from app.core.registry import MODELS
from app.core.tflite_inference import run_tflite_model

router = APIRouter(
    prefix="/predict/tf5-performance",
    tags=["TF5 - Performance"]
)

@router.post("", response_model=TF5PerformanceResponse)
def predict_performance(req: TF5PerformanceRequest):
    interpreter = MODELS["tf5"]

    input_values = [
    req.task_completion_rate,
    req.avg_task_priority,
    req.focus_score_avg,
    req.distraction_prob_avg,
    req.context_success_rate,
    req.wellness_score,
    req.sleep_deviation_hours,
]

    score = run_tflite_model(interpreter, input_values)

    return TF5PerformanceResponse(performance_score=score)
