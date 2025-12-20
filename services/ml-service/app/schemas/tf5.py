from pydantic import BaseModel, Field

class TF5PerformanceRequest(BaseModel):
    task_completion_rate: float = Field(0.5, ge=0.0, le=1.0)
    avg_task_priority: float = Field(0.5, ge=0.0, le=1.0)
    focus_score_avg: float = Field(0.5, ge=0.0, le=1.0)
    distraction_prob_avg:float = Field(0.5, ge=0.0, le=1.0)
    context_success_rate: float = Field(0.5, ge=0.0, le=1.0)
    wellness_score: float = Field(0.5, ge=0.0, le=1.0)
    sleep_deviation_hours: float = Field(0.0)


class TF5PerformanceResponse(BaseModel):
    performance_score: float
