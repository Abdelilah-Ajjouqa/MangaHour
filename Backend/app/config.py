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


@lru_cache
def get_settings() -> Settings:
    return Settings()
