---
name: fastapi-clean
description: >
  FastAPI clean architecture project scaffolding with business logic layer,
  routers, and Docker configuration with dev/prod overrides.
  Trigger: When creating new FastAPI projects or initializing FastAPI services.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---

## When to Use

- Initializing new FastAPI microservices or APIs
- Scaffolding clean architecture structure
- Setting up Docker with environment-specific overrides
- Creating modular, scalable FastAPI applications

## Architecture Overview

```
project/
├── app/
│   ├── __init__.py
│   ├── main.py              # Entry point - imports routers
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py        # Settings (env vars, secrets)
│   │   └── dependencies.py  # Shared dependencies
│   ├── routers/             # HTTP endpoints (thin layer)
│   │   ├── __init__.py      # Aggregates all routers
│   │   └── health.py        # /health endpoint
│   ├── services/            # Business logic
│   │   ├── __init__.py
│   │   └── health_service.py
│   └── schemas/             # Pydantic models
│       ├── __init__.py
│       └── health.py
├── tests/
├── Dockerfile
├── docker-compose.yml       # Base configuration
├── docker-compose.override.yml  # Dev (auto-loaded)
├── docker-compose.prod.yml      # Prod explicit override
├── requirements.txt
└── pyproject.toml
```

## Critical Patterns

### 1. Service Layer (app/services/)

Business logic lives in `app/services/`, isolated from HTTP layer:

```python
# app/services/health_service.py
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
```

### 2. Schemas (app/schemas/)

Pydantic models in dedicated folder:

```python
# app/schemas/health.py
from pydantic import BaseModel
from datetime import datetime


class HealthStatus(BaseModel):
    status: str
    timestamp: str
    version: str
```

### 3. Routers (app/routers/)

Thin routers that delegate to services:

```python
# app/routers/health.py
from fastapi import APIRouter
from app.services.health_service import HealthService
from app.schemas.health import HealthStatus

router = APIRouter(tags=["health"])


@router.get("/health", response_model=HealthStatus)
def health_check() -> HealthStatus:
    return HealthService.get_health()
```

### 4. Router Aggregation (app/routers/__init__.py)

```python
# app/routers/__init__.py
from fastapi import APIRouter
from app.routers.health import router as health_router

api_router = APIRouter()

api_router.include_router(health_router)
# Add more routers:
# from app.routers.users import router as users_router
# api_router.include_router(users_router, prefix="/api/v1")
```

## Docker Strategy

### Base (docker-compose.yml)
Common config shared between environments.

### Dev Override (docker-compose.override.yml)
Auto-loaded by `docker compose up`. Includes:
- Volume mounts for hot reload
- Debug ports exposed
- Development environment variables
- Uvicorn with --reload

### Prod Override (docker-compose.prod.yml)
Explicit: `docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d`
- No volume mounts
- Optimized image
- Production environment variables
- Multiple workers

## Commands

```bash
# Development (auto-loads override)
docker compose up -d

# Production
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Build
docker compose build

# View logs
docker compose logs -f app

# Run migrations (if using alembic)
docker compose exec app alembic upgrade head
```

## Quick Start Checklist

- [ ] Copy project structure from assets
- [ ] Update `app/core/config.py` with project settings
- [ ] Create schemas in `app/schemas/`
- [ ] Create services in `app/services/`
- [ ] Create routers in `app/routers/`
- [ ] Register router in `app/routers/__init__.py`
- [ ] Update `docker-compose.yml` service name if needed
- [ ] Add dependencies to `requirements.txt`

## Resources

- **Project Template**: See [assets/](assets/) for complete scaffolding
