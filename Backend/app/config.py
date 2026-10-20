from functools import lru_cache

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    database_url: str = "postgresql+psycopg://mangahour:mangahour@localhost:55432/mangahour"
    db_pool_size: int = Field(default=5, ge=1, le=50)
    db_max_overflow: int = Field(default=5, ge=0, le=50)
    sync_interval_seconds: int = Field(default=10800, ge=60)
    mangadex_base_url: str = "https://api.mangadex.org"
    mangadex_requests_per_second: float = Field(default=2, gt=0, le=4)
    mangadex_timeout_seconds: float = Field(default=20, gt=0, le=60)
    mangadex_max_attempts: int = Field(default=3, ge=1, le=5)


@lru_cache
def get_settings() -> Settings:
    return Settings()
