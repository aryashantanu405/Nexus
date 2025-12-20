from pydantic import BaseModel, Field

class TF1PriorityRequest(BaseModel):
    time_until_deadline: float = Field(..., ge=0)
    task_duration: float = Field(..., ge=0)

    task_importance: float = Field(0.5, ge=0.0, le=1.0)

    category_academic: int = Field(0, ge=0, le=1)
    category_work: int = Field(0, ge=0, le=1)
    category_personal: int = Field(0, ge=0, le=1)

    user_fatigue_level: float = Field(0.5, ge=0.0, le=1.0)
    past_delay_rate: float = Field(0.0, ge=0.0, le=1.0)
    urgency_factor: float = Field(0.5, ge=0.0, le=1.0)
    capacity_mismatch: float = Field(0.0, ge=0.0, le=1.0)


class TF1PriorityResponse(BaseModel):
    priority_score: float
