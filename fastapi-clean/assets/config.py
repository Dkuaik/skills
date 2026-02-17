from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    PROJECT_NAME: str = "fastapi-app"
    VERSION: str = "0.1.0"
    DEBUG: bool = False
    LOG_LEVEL: str = "info"

    # Database (example)
    DATABASE_URL: str = "sqlite:///./app.db"

    # CORS
    CORS_ORIGINS: list[str] = ["*"]

    model_config = {
        "env_file": ".env",
        "env_file_encoding": "utf-8",
        "case_sensitive": True,
    }


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
