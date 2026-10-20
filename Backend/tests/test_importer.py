import os
from uuid import UUID, uuid4

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine, func, select
from sqlalchemy.orm import Session

from app.database import get_session
from app.importer import import_manga, manga_record
from app.main import app
from app.mangadex import MangaDexError
from app.models import Chapter, SyncCheckpoint


def manga_data(manga_id, rating="safe"):
    return {"id": str(manga_id), "attributes": {
        "title": {"en": "Example", "ar": "Arabic title"}, "description": {"en": "Description"},
        "contentRating": rating, "originalLanguage": "ja", "updatedAt": "2026-01-01T00:00:00Z",
        "links": {"mal": "123"},
    }}


def chapter_data(chapter_id, language):
    return {"id": str(chapter_id), "attributes": {
        "chapter": "1", "translatedLanguage": language, "pages": 12,
        "publishAt": "2026-01-01T00:00:00Z", "updatedAt": "2026-01-01T00:00:00Z",
    }}


def test_preserves_localized_titles_and_mappings():
    record = manga_record(manga_data(uuid4()))
    assert record["title"] == "Arabic title"
    assert record["titles"]["en"] == "Example"
    assert record["source_links"] == {"mal": "123"}


def test_rejects_disabled_content_ratings():
    with pytest.raises(ValueError, match="safe and suggestive"):
        manga_record(manga_data(uuid4(), "erotica"))


@pytest.fixture
def session():
    url = os.environ.get("TEST_DATABASE_URL")
    if not url:
        pytest.skip("Set TEST_DATABASE_URL to a migrated PostgreSQL database")
    engine = create_engine(url)
    with engine.connect() as connection:
        transaction = connection.begin()
        with Session(bind=connection, join_transaction_mode="create_savepoint") as session:
            yield session
        transaction.rollback()
    engine.dispose()


def test_reimport_preserves_releases_and_api_pagination(session):
    manga_id = uuid4()
    releases = [chapter_data(uuid4(), "en"), chapter_data(uuid4(), "ar")]

    class Source:
        def manga(self, identifier):
            return manga_data(manga_id)

        def chapters(self, identifier, offset):
            return {"data": releases[offset:offset + 1], "total": 2}

    assert import_manga(session, Source(), manga_id) == 2
    assert import_manga(session, Source(), manga_id) == 2
    assert session.scalar(select(func.count()).select_from(Chapter).where(Chapter.manga_id == manga_id)) == 2
    assert session.get(SyncCheckpoint, f"manga:{manga_id}").watermark is not None
    app.dependency_overrides[get_session] = lambda: session
    try:
        with TestClient(app) as client:
            details = client.get(f"/v1/manga/{manga_id}")
            assert details.status_code == 200
            assert details.json()["source_links"]["mal"] == "123"
            page = client.get(f"/v1/manga/{manga_id}/chapters?limit=1").json()
            assert len(page["items"]) == 1
            assert page["has_more"] is True
            filtered = client.get(f"/v1/manga/{manga_id}/chapters?language=ar").json()
            assert filtered["items"][0]["language"] == "ar"
            assert client.get(f"/v1/manga/{manga_id}/chapters?limit=101").status_code == 422
    finally:
        app.dependency_overrides.clear()


def test_interrupted_import_keeps_batch_but_not_completion_checkpoint(session):
    manga_id = uuid4()
    release = chapter_data(uuid4(), "en")

    class Source:
        def manga(self, identifier):
            return manga_data(manga_id)

        def chapters(self, identifier, offset):
            if offset:
                raise MangaDexError("interrupted")
            return {"data": [release], "total": 2}

    with pytest.raises(MangaDexError, match="interrupted"):
        import_manga(session, Source(), manga_id)
    assert session.get(Chapter, UUID(release["id"])) is not None
    assert session.get(SyncCheckpoint, f"manga:{manga_id}") is None
