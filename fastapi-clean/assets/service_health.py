from datetime import datetime
from app.core.config import settings
from app.schemas.health import HealthStatus


class HealthService:
    @staticmethod
    def get_health() -> HealthStatus:
        return HealthStatus(
            status="healthy",
            timestamp=datetime.utcnow().isoformat(),
            version=settings.VERSION,
        )

    @staticmethod
    def get_ready() -> bool:
        # Add checks for dependencies (db, redis, etc.)
        return True
