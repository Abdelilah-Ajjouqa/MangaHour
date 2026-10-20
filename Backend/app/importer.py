import argparse
import logging
from datetime import datetime, timezone
from uuid import UUID

import httpx
from sqlalchemy import text
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from app.config import get_settings
from app.database import get_engine
from app.mangadex import MangaDexClient, MangaDexError
from app.models import Chapter, Manga, SyncCheckpoint

IMPORT_LOCK = 72941001


def parse_date(value: str) -> datetime:
    parsed = datetime.fromisoformat(value.replace("Z", "+00:00"))
    return parsed.replace(tzinfo=timezone.utc) if parsed.tzinfo is None else parsed


def manga_record(data: dict) -> dict:
    attributes = data["attributes"]
    if attributes["contentRating"] not in {"safe", "suggestive"}:
        raise ValueError("Only safe and suggestive manga are enabled")
    titles = attributes.get("title") or {}
    descriptions = attributes.get("description") or {}
    relationships = data.get("relationships", [])
    return {
        "id": UUID(data["id"]),
        "title": titles.get("ar") or titles.get("en") or next(iter(titles.values()), "Untitled"),
        "description": descriptions.get("ar") or descriptions.get("en") or "",
        "titles": titles,
        "alternate_titles": attributes.get("altTitles") or [],
        "descriptions": descriptions,
        "source_links": attributes.get("links") or {},
        "tags": attributes.get("tags") or [],
        "creators": [r for r in relationships if r["type"] in {"author", "artist"}],
        "status": attributes.get("status", "unknown"),
        "year": attributes.get("year"),
        "cover_filename": next(
            (r.get("attributes", {}).get("fileName") for r in relationships if r["type"] == "cover_art"),
            None,
        ),
        "original_language": attributes["originalLanguage"],
        "content_rating": attributes["contentRating"],
        "source_updated_at": parse_date(attributes["updatedAt"]),
        "synced_at": datetime.now(timezone.utc),
    }


def chapter_record(data: dict, manga_id: UUID) -> dict:
    attributes = data["attributes"]
    return {
        "id": UUID(data["id"]), "manga_id": manga_id,
        "title": attributes.get("title"), "number": attributes.get("chapter"),
        "volume": attributes.get("volume"), "language": attributes["translatedLanguage"],
        "pages": attributes.get("pages", 0),
        "published_at": parse_date(attributes["publishAt"]),
        "source_updated_at": parse_date(attributes["updatedAt"]),
        "groups": [r for r in data.get("relationships", []) if r["type"] == "scanlation_group"],
        "external_url": attributes.get("externalUrl"),
    }


def upsert(session: Session, model, records: list[dict]) -> None:
    if not records:
        return
    statement = insert(model).values(records)
    session.execute(statement.on_conflict_do_update(
        index_elements=[model.id],
        set_={key: getattr(statement.excluded, key) for key in records[0] if key != "id"},
        where=model.source_updated_at <= statement.excluded.source_updated_at,
    ))


def import_manga(session: Session, client: MangaDexClient, manga_id: UUID) -> int:
    started = datetime.now(timezone.utc)
    upsert(session, Manga, [manga_record(client.manga(str(manga_id)))])
    session.commit()
    offset = 0
    while True:
        payload = client.chapters(str(manga_id), offset)
        data = payload["data"]
        total = payload["total"]
        if total > 10000:
            raise MangaDexError("Feed exceeds 10,000 results; filtered partitioning is required")
        if not data and offset < total:
            raise MangaDexError("Incomplete chapter feed; import checkpoint was not advanced")
        records = [
            chapter_record(item, manga_id) for item in data
            if item["attributes"]["translatedLanguage"] in {"ar", "en"}
            and parse_date(item["attributes"]["publishAt"]) <= datetime.now(timezone.utc)
        ]
        upsert(session, Chapter, records)
        session.commit()
        offset += len(data)
        if offset >= total:
            break
    checkpoint = session.get(SyncCheckpoint, f"manga:{manga_id}")
    if checkpoint is None:
        checkpoint = SyncCheckpoint(name=f"manga:{manga_id}")
        session.add(checkpoint)
    checkpoint.watermark = started
    checkpoint.updated_at = datetime.now(timezone.utc)
    session.commit()
    return offset


def main() -> None:
    parser = argparse.ArgumentParser(description="Import one MangaDex manga and its Arabic/English feed")
    parser.add_argument("manga_id", type=UUID)
    args = parser.parse_args()
    logging.basicConfig(level=logging.INFO)
    settings = get_settings()
    try:
        with get_engine().connect() as lock_connection:
            locked = lock_connection.execute(text("SELECT pg_try_advisory_lock(:id)"), {"id": IMPORT_LOCK}).scalar()
            lock_connection.commit()
            if not locked:
                raise MangaDexError("Another importer is active; try later")
            try:
                with Session(get_engine()) as session, httpx.Client(
                    base_url=settings.mangadex_base_url,
                    timeout=settings.mangadex_timeout_seconds,
                    headers={"User-Agent": "MangaHourAPI/0.1 (metadata importer)"},
                ) as http:
                    client = MangaDexClient(
                        http, settings.mangadex_requests_per_second, settings.mangadex_max_attempts,
                    )
                    count = import_manga(session, client, args.manga_id)
                    logging.info("Imported manga %s; scanned %s chapter releases", args.manga_id, count)
            finally:
                lock_connection.execute(text("SELECT pg_advisory_unlock(:id)"), {"id": IMPORT_LOCK})
                lock_connection.commit()
    except (MangaDexError, ValueError, KeyError, TypeError, httpx.HTTPError) as exc:
        parser.exit(1, f"Import failed: {exc}\n")


if __name__ == "__main__":
    main()
