from pydantic import BaseModel, Field

class TF2FocusRequest(BaseModel):
    session_duration: float = Field(..., ge=0)

    screen_unlocks: int = Field(0, ge=0)
    app_switches: int = Field(0, ge=0)

    focus_app_ratio: float = Field(0.5, ge=0.0, le=1.0)

    notification_count: int = Field(0, ge=0)
    notification_clicked_ratio: float = Field(0.0, ge=0.0, le=1.0)

    idle_time_ratio: float = Field(0.0, ge=0.0, le=1.0)
    task_progress: float = Field(0.5, ge=0.0, le=1.0)

    break_overdue: int = Field(0, ge=0, le=1)


class TF2FocusResponse(BaseModel):
    focus_score: float
