from pydantic import BaseModel


class HealthStatus(BaseModel):
    status: str
    timestamp: str
    version: str
