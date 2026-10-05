from contextlib import asynccontextmanager

from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from app.database import get_engine, get_session


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield
    if get_engine.cache_info().currsize:
        get_engine().dispose()
        get_engine.cache_clear()


app = FastAPI(title="MangaHour API", version="0.1.0", lifespan=lifespan)


@app.get("/health/live", tags=["health"])
def liveness() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/health/ready", tags=["health"])
def readiness(session: Session = Depends(get_session)) -> dict[str, str]:
    try:
        session.execute(text("SELECT 1 FROM sync_checkpoint LIMIT 1"))
    except SQLAlchemyError:
        raise HTTPException(status_code=503, detail="Database is not ready") from None
    return {"status": "ok"}
