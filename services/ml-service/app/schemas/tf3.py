from pydantic import BaseModel, Field

class TF3ContextRequest(BaseModel):
    weather_risk: float = Field(0.0, ge=0.0, le=1.0)
    traffic_delay: float = Field(0.0, ge=0.0)
    task_importance: float = Field(0.5, ge=0.0, le=1.0)
    distance_to_location: float = Field(0.0, ge=0.0)

    battery_level: float = Field(0.5, ge=0.0, le=1.0)



class TF3ContextResponse(BaseModel):
    context_score: float
