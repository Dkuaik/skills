from fastapi import APIRouter, HTTPException
from app.services.health_service import HealthService
from app.schemas.health import HealthStatus

router = APIRouter(tags=["health"])


@router.get("/health", response_model=HealthStatus)
def health_check() -> HealthStatus:
    return HealthService.get_health()


@router.get("/ready")
def readiness_check():
    if not HealthService.get_ready():
        raise HTTPException(status_code=503, detail="Service not ready")
    return {"status": "ready"}
