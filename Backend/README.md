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
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -e ".[dev]"
Copy-Item .env.example .env
docker compose up -d db
alembic upgrade head
uvicorn app.main:app --reload
```

## Scope

Implemented: environment configuration, bounded connection pooling, database timeouts,
health endpoints, catalog schema, migration tooling, local containers, health tests.

Next: MangaDex client and throttling, resumable import, incremental sync and locking,
alternate titles and source mappings, paginated catalog APIs, Arabic search, load tests.
The worker entry point deliberately exits until sync is implemented; its Compose profile
is disabled by default. No MangaDex requests or imports run yet.

Metadata will be served from PostgreSQL. Chapter images will not be stored or proxied
by this initial backend. Upstream limits must be confirmed before enabling imports.
