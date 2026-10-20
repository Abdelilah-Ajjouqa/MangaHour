from datetime import datetime
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, ConfigDict
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_session
from app.models import Chapter, Manga

router = APIRouter(prefix="/v1", tags=["catalog"])


class MangaDetails(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: UUID
    title: str
    titles: dict
    alternate_titles: list
    descriptions: dict
    source_links: dict
    tags: list
    creators: list
    status: str
    year: int | None
    cover_filename: str | None
    original_language: str
    content_rating: str
    synced_at: datetime


class ChapterDetails(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: UUID
    title: str | None
    number: str | None
    volume: str | None
    language: str
    pages: int
    published_at: datetime
    groups: list
    external_url: str | None


class ChapterPage(BaseModel):
    items: list[ChapterDetails]
    offset: int
    limit: int
    has_more: bool


@router.get("/manga/{manga_id}", response_model=MangaDetails)
def manga_details(manga_id: UUID, session: Session = Depends(get_session)):
    manga = session.get(Manga, manga_id)
    if manga is None:
        raise HTTPException(404, "Manga not found")
    return manga


@router.get("/manga/{manga_id}/chapters", response_model=ChapterPage)
def chapters(
    manga_id: UUID,
    language: str | None = Query(default=None, pattern="^(ar|en)$"),
    limit: int = Query(default=50, ge=1, le=100),
    offset: int = Query(default=0, ge=0, le=10000),
    session: Session = Depends(get_session),
):
    if session.get(Manga, manga_id) is None:
        raise HTTPException(404, "Manga not found")
    query = select(Chapter).where(Chapter.manga_id == manga_id)
    if language:
        query = query.where(Chapter.language == language)
    rows = session.scalars(
        query.order_by(Chapter.published_at, Chapter.id).offset(offset).limit(limit + 1)
    ).all()
    return {"items": rows[:limit], "offset": offset, "limit": limit, "has_more": len(rows) > limit}
