# MangaHour Backend

FastAPI and PostgreSQL foundation for a shared MangaDex catalog. The frontend is independent.

## Run with Docker

Start Docker Desktop, then from this directory:

```powershell
docker compose up --build -d
docker compose logs api
```

Compose starts PostgreSQL, applies migrations once, and starts the API.
API documentation: http://localhost:8000/docs
Liveness: http://localhost:8000/health/live
Database and schema readiness: http://localhost:8000/health/ready
PostgreSQL is available to Windows tools on `localhost:55432`.
Containers connect to `db:5432`.

The included credentials and localhost port bindings are for local development only.
Database data persists in the `postgres_data` volume. `docker compose down` keeps it.

## Checks

```powershell
docker compose run --rm --no-deps api pytest -p no:cacheprovider
docker compose run --rm --no-deps api ruff check --no-cache .
docker compose exec -T api alembic check
```

## Run with Python 3.12+

```powershell
uv sync --locked --extra dev
docker compose up -d db
uv run --locked alembic upgrade head
uv run --locked uvicorn app.main:app --reload --port 8001
```

The default local database URL uses `localhost:55432`. For custom settings, copy
`.env.example` to `.env` if you do not already have one. Port 8001 avoids conflicts
with the Docker API on port 8000. Local docs: http://localhost:8001/docs

Local checks:

```powershell
uv run --locked --extra dev pytest -p no:cacheprovider
uv run --locked --extra dev ruff check .
```

## Docker Development Reload

```powershell
docker compose -f compose.yaml -f compose.dev.yaml up --build -d
```

Python edits under `app/` restart the API automatically. Dependencies are installed
from `uv.lock`; changing dependencies requires rebuilding. To return to the normal
image-based configuration, run `docker compose up -d`.

## Scope

Implemented: locked environments, bounded connection pooling, database timeouts,
health endpoints, localized catalog metadata, source links, cover references, migrations,
single-title importing, database-only manga details and paginated chapter APIs.

Next: partitioned catalog importing, incremental sync, removal reconciliation,
manga lists, latest updates, Arabic search, load tests.
The worker entry point deliberately exits until sync is implemented; its Compose profile
is disabled by default. Imports run only when explicitly invoked.

Metadata will be served from PostgreSQL. Chapter images will not be stored or proxied
by this initial backend. Upstream limits must be confirmed before enabling imports.

## Import One Title

```powershell
docker compose exec -T api python -m app.importer ba7908db-5c9e-4f78-9fc1-3b3581f752e9
# Alternatively, with local Python:
uv run --locked python -m app.importer ba7908db-5c9e-4f78-9fc1-3b3581f752e9
```

The argument is a MangaDex UUID, not a MyAnimeList ID. Only safe/suggestive manga
and Arabic/English chapters are enabled. Every release retains its own source UUID,
language and scanlation groups. External releases retain their external URL.

The importer serializes upstream work using a PostgreSQL advisory lock and defaults
to two requests per second. Network/5xx failures have bounded retries; HTTP 429 ends
the run without repeatedly retrying. Respect the reported delay before rerunning.
Completed pages remain committed if a later request fails. Rerun the same command
to rescan the feed with idempotent upserts; completion checkpoints advance only after
the entire feed succeeds. This deliberately rechecks earlier pages instead of resuming
an offset that could skip releases when the upstream feed changes.

Feeds over 10,000 results fail explicitly until filtered partitioning is implemented.
Deleted upstream releases are not reconciled yet. Stored data is not a complete mirror.

Available endpoints:

- `GET /v1/manga/{id}`
- `GET /v1/manga/{id}/chapters?language=ar&limit=50&offset=0`

Chapter pagination uses publication date and UUID ordering and retains all matching
releases. Chapter-number ordering, catalog search and incremental sync are future work.

Run the complete suite, including rollback-isolated PostgreSQL integration tests:

```powershell
docker compose exec -T -e TEST_DATABASE_URL=postgresql+psycopg://mangahour:mangahour@db:5432/mangahour api pytest -p no:cacheprovider
```
