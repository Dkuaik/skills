from fastapi import APIRouter
from app.routers.health import router as health_router

api_router = APIRouter()

api_router.include_router(health_router)
# Add more routers here:
# from app.routers.users import router as users_router
# api_router.include_router(users_router, prefix="/api/v1")
