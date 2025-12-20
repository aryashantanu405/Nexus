from pydantic import BaseModel, Field

class TF4WellnessRequest(BaseModel):
    task_priority_avg: float = Field(0.5, ge=0.0, le=1.0)
    focus_score_avg: float = Field(0.5, ge=0.0, le=1.0)

    screen_time_hours: float = Field(0.0, ge=0.0)
    mood_score: float = Field(0.5, ge=0.0, le=1.0)


class TF4WellnessResponse(BaseModel):
    wellness_score: float
