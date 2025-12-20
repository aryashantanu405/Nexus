from fastapi import FastAPI

from app.routes.tf1_priority import router as tf1_router
from app.routes.tf2_focus import router as tf2_router
from app.routes.tf3_context import router as tf3_router
from app.routes.tf4_wellness import router as tf4_router
from app.routes.tf5_performance import router as tf5_router

app = FastAPI(title="Nexus ML Backend")

app.include_router(tf1_router)
app.include_router(tf2_router)
app.include_router(tf3_router)
app.include_router(tf4_router)
app.include_router(tf5_router)

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/")
def root():
    return {
        "message": "Nexus ML Backend is running",
        "docs": "/docs",
        "health": "/health"
    }
