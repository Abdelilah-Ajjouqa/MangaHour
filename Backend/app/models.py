from datetime import datetime
from uuid import UUID

from sqlalchemy import JSON, DateTime, ForeignKey, Index, Integer, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Manga(Base):
    __tablename__ = "manga"

    id: Mapped[UUID] = mapped_column(primary_key=True)
    title: Mapped[str] = mapped_column(String(512))
    description: Mapped[str] = mapped_column(Text, default="")
    titles: Mapped[dict] = mapped_column(JSON, default=dict)
    alternate_titles: Mapped[list] = mapped_column(JSON, default=list)
    descriptions: Mapped[dict] = mapped_column(JSON, default=dict)
    source_links: Mapped[dict] = mapped_column(JSON, default=dict)
    tags: Mapped[list] = mapped_column(JSON, default=list)
    creators: Mapped[list] = mapped_column(JSON, default=list)
    status: Mapped[str] = mapped_column(String(32), default="unknown")
    year: Mapped[int | None] = mapped_column(Integer)
    cover_filename: Mapped[str | None] = mapped_column(String(512))
    original_language: Mapped[str] = mapped_column(String(16))
    content_rating: Mapped[str] = mapped_column(String(32))
    source_updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    synced_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    __table_args__ = (Index("ix_manga_source_updated_at", "source_updated_at", "id"),)


class Chapter(Base):
    __tablename__ = "chapter"

    id: Mapped[UUID] = mapped_column(primary_key=True)
    manga_id: Mapped[UUID] = mapped_column(ForeignKey("manga.id", ondelete="CASCADE"))
    title: Mapped[str | None] = mapped_column(String(512))
    number: Mapped[str | None] = mapped_column(String(64))
    volume: Mapped[str | None] = mapped_column(String(64))
    language: Mapped[str] = mapped_column(String(16))
    pages: Mapped[int] = mapped_column(Integer)
    published_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    source_updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))

    __table_args__ = (
        Index("ix_chapter_manga_language_published", "manga_id", "language", "published_at", "id"),
    )
    groups: Mapped[list] = mapped_column(JSON, default=list)
    external_url: Mapped[str | None] = mapped_column(Text)


class SyncCheckpoint(Base):
    __tablename__ = "sync_checkpoint"

    name: Mapped[str] = mapped_column(String(64), primary_key=True)
    watermark: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
