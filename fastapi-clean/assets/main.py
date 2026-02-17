from contextlib import asynccontextmanager
from fastapi import FastAPI
from app.routers import api_router
from app.core.config import settings


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: create tables, init resources
    yield
    # Shutdown: cleanup resources


app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
    lifespan=lifespan,
)

app.include_router(api_router)
