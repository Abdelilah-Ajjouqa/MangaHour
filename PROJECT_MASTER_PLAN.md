# MangaHour — Master Product & Engineering Plan

**Status:** Active source of truth

**Last updated:** 2026-10-12

## 1. Product Idea

MangaHour is an Arabic-first, RTL-first manga, manhwa, and manhua reader for mobile.
It should feel fast and reliable even when the upstream manga source is slow, rate-limited,
or temporarily unavailable.

The core user journey is:

1. Discover or search for a title.
2. Open a title and browse available releases.
3. Select a chapter and read it in a comfortable reader.
4. Save progress, favorites, and history.
5. Return to continue reading or discover newly released chapters.

Arabic is the primary experience. English is a supported fallback. The product must handle
RTL text, Arabic translations, and English releases without treating either as an afterthought.

## 2. Product Principles

- The application reads from MangaHour services for catalog data, never directly from an
  upstream source during normal browsing.
- MangaHour stores metadata and chapter-release records. It does not mirror or proxy chapter
  image files in the first release.
- The user experience must remain useful during a MangaDex outage by serving the last known
  catalog data.
- The app needs a controlled remote-update system for screens and feature availability, so
  many changes do not require an App Store or Play Store release.
- The reader remains mostly client-side because page gestures, image rendering, and offline
  behavior require low latency and predictable native behavior.
- APIs are versioned, bounded, observable, and safe to evolve.

## 3. Architecture

```text
                      MangaDex API
                           ^
                           | controlled imports and incremental sync
                           |
                 +--------------------+
                 | Sync worker        |
                 | lock, throttle,    |
                 | checkpoint, retry  |
                 +---------+----------+
                           |
                           v
                 +--------------------+
                 | PostgreSQL         |
                 | catalog, releases, |
                 | sync state, SDUI   |
                 +---------+----------+
                           ^
                           |
        +------------------+------------------+
        |                                     |
        v                                     v
+--------------------+              +-----------------------+
| Catalog API        |              | BFF / SDUI API        |
| search, title,     |              | screen definitions,   |
| chapters, updates  |              | feature flags, data   |
+---------+----------+              +----------+------------+
          |                                    |
          +----------------+-------------------+
                           v
                 +--------------------+
                 | Flutter application|
                 | SDUI renderer +    |
                 | native reader      |
                 +--------------------+
```

### 3.1 Backend stack

| Area | Choice | Reason |
|---|---|---|
| API | Python 3.12 + FastAPI | Typed HTTP API and automatic API documentation |
| Data | PostgreSQL | Durable catalog, indexing, transactions, locks, and search foundation |
| ORM and migrations | SQLAlchemy + Alembic | Explicit data model and versioned database changes |
| HTTP client | HTTPX | Timeouts, controlled upstream requests, and testable client behavior |
| Dependency management | uv + `uv.lock` | Reproducible local and container installs |
| Local runtime | Docker Compose | API, database, migration job, worker, and consistent setup |
| Tests | pytest + Ruff | Behavior checks and static quality checks |

Redis and a queue are deliberately deferred. PostgreSQL is sufficient for the first worker,
sync checkpoints, and coordination at the planned initial scale of roughly 1,000 daily users.

### 3.2 BFF strategy

The FastAPI service is both the catalog API and the initial BFF. It will offer two API styles:

- **Resource APIs:** stable data contracts such as a manga, a chapter page, or search results.
- **Experience APIs:** screen-shaped responses such as a home feed, discovery screen, or
  library summary.

This avoids creating a second service before there is evidence that web and mobile need
different server behavior. If they diverge later, their BFF layers can separate while sharing
the catalog domain and database.

### 3.3 SDUI strategy

SDUI is a core product capability, not a decorative add-on. It enables remote changes to
supported layouts and features without waiting for mobile-store review.

The backend will deliver versioned screen definitions. The Flutter client will render only a
known, reviewed set of component types. A server response can choose and configure those
components; it cannot inject arbitrary executable code.

Examples of remotely changeable behavior:

- Home-screen sections, section order, labels, artwork, and content rules.
- Discovery layouts, empty states, promotional surfaces, and maintenance messages.
- Supported reader settings, feature flags, and experiments.
- Temporary removal or rollback of a broken server-configured feature.

Examples that still require a mobile release:

- A component type the installed app does not support.
- New native permissions, platform integrations, or dependencies.
- A client-side crash, security issue, or new reader interaction not already built in.

Every SDUI response must include a schema version, minimum client version, screen identity,
revision, expiry, and fallback behavior. The client must cache the last valid screen and retain
a basic built-in fallback for essential navigation.

## 4. MangaDex Data Strategy

### 4.1 Stored data

MangaHour stores:

- MangaDex UUIDs, titles, alternate titles, localized descriptions, tags, creators, cover file
  references, source links, status, content rating, and source timestamps.
- Every chapter release as its own record, including source UUID, manga UUID, chapter and
  volume number, language, publish time, page count, scanlation group references, and external
  URL where present.
- Sync checkpoints and job state.

Keeping each release prevents Arabic and English translations, or multiple scanlation-group
releases, from overwriting one another.

### 4.2 Upstream rules

- Importing is sequential and uses one shared request budget.
- Default rate is two MangaDex requests per second, below the documented global floor.
- Requests have timeouts and a bounded retry policy for network and 5xx failures.
- A rate-limit response ends the current import rather than repeatedly retrying it.
- The worker observes relevant rate-limit headers and waits before a later run.
- Only `safe` and `suggestive` content ratings are in initial scope.
- Only Arabic and English releases are in initial scope.

### 4.3 Initial import and sync

The initial import is not one enormous request. MangaDex collection endpoints are paginated and
have a result cap, so the catalog must be imported in filtered partitions. Candidate partitions
include source update time windows and language/content-rating filters.

Each page is committed independently. If a job stops, completed pages remain available and a
future run can safely reprocess them through idempotent upserts. A PostgreSQL advisory lock
prevents two importers from consuming the same upstream budget simultaneously.

After the catalog is seeded, the worker will run every three hours:

1. Read the last successful sync checkpoint.
2. Fetch records updated since a slightly earlier overlapping time window.
3. Upsert manga and release records by MangaDex UUID.
4. Advance the checkpoint only after the full run succeeds.
5. Periodically reconcile unavailable or removed records.

The overlap protects against delayed publication and clock differences. Reconciliation is
separate because an update feed alone cannot reliably represent every deletion or availability
change.

### 4.4 Image delivery

The first backend does not proxy or store chapter image bytes. That would add a distinct
bandwidth, storage, licensing, and source-delivery problem. The reader can obtain valid page
delivery information using the source-supported method when the user starts a chapter.

## 5. API Contract Direction

### Stable resource endpoints

| Endpoint | Purpose | Status |
|---|---|---|
| `GET /health/live` | Process liveness | Built |
| `GET /health/ready` | Database and schema readiness | Built |
| `GET /v1/manga/{id}` | One title's stored metadata | Built |
| `GET /v1/manga/{id}/chapters` | Bounded, language-filterable release page | Built |
| `GET /v1/manga` | Browse catalog with cursor pagination | Planned |
| `GET /v1/search` | Arabic/English title search | Planned |
| `GET /v1/updates` | Latest chapter releases | Planned |

### Experience and SDUI endpoints

| Endpoint | Purpose | Status |
|---|---|---|
| `GET /v1/experience/bootstrap` | Client capabilities, global configuration, feature flags | Planned |
| `GET /v1/experience/screens/{screen}` | Versioned SDUI definition plus referenced content | Planned |
| `GET /v1/home` | Mobile-oriented home BFF response | Planned |
| `GET /v1/discover` | Mobile-oriented discovery BFF response | Planned |

The application should report its version, platform, locale, layout direction, and supported
SDUI component versions. The server selects only a compatible screen definition.

## 6. Data Model Roadmap

### Built

- `manga`: localized metadata, source links, tags, creators, cover reference, status, rating,
  and source timestamps.
- `chapter`: source release records, language, chapter metadata, scanlation groups, and dates.
- `sync_checkpoint`: successful import and sync watermarks.

### Planned

- `manga_search_document` or indexed generated fields for Arabic, English, romanized, and
  alternate-title search.
- `sync_run` for start/end time, status, counters, source response information, and errors.
- `sdui_screen` and `sdui_screen_revision` for draft, validation, scheduled publishing,
  immediate rollback, and audit history.
- `feature_flag` and targeting rules.
- Optional account, favorites, reading progress, and user-device tables once cross-device sync
  becomes a product requirement.

## 7. Delivery Milestones

### Milestone A — Backend foundation

**Status: complete**

- Docker Compose environment and PostgreSQL.
- FastAPI health endpoints.
- SQLAlchemy models and Alembic migrations.
- `uv.lock`-based local and container installs.
- Database connection limits and timeouts.
- Development reload configuration.

### Milestone B — Single-title catalog import

**Status: complete**

- MangaDex client with throttling, timeout, and bounded retry behavior.
- Single-title import for safe/suggestive manga and Arabic/English releases.
- Idempotent upserts and importer lock.
- Completion checkpoints.
- Manga-details and paginated chapter APIs.
- Automated tests, including PostgreSQL integration coverage.

### Milestone C — Catalog seeding and scheduled sync

**Status: next**

- Design partitioning strategy that cannot skip or exceed source result limits.
- Create observable sync-run records and job summaries.
- Implement catalog seeding command with resumable partitions.
- Implement incremental three-hour sync with overlap window.
- Add removal/unavailability reconciliation.
- Replace the placeholder worker with a controlled scheduling loop.

### Milestone D — Catalog experience APIs

- Browse lists and latest updates with cursor pagination.
- Arabic, English, romanized, and alternate-title search.
- Database indexes and query plans validated against representative data.
- Home and discovery BFF responses.
- HTTP response caching contracts such as ETags where appropriate.

### Milestone E — SDUI platform

- Define and version the SDUI schema.
- Implement client capability negotiation.
- Define initial component catalog: section container, manga rail, manga grid, title header,
  action, notice, empty state, loading state, and supported reader configuration.
- Store, validate, preview, publish, rollback, and audit screen revisions.
- Add fallback screens and expiry policies in the Flutter client.
- Add remote feature flags with safe defaults and staged rollout support.

### Milestone F — New Flutter application

- Rebuild UI around Arabic-first typography and RTL ergonomics.
- Implement the SDUI renderer and cached fallback layer.
- Implement native reader modes, chapter navigation, image delivery, and local offline support.
- Connect browsing, search, favorites, history, and reader progress to the backend contracts.

### Milestone G — Production readiness

- Structured logging and dashboards for request latency, failures, sync lag, upstream
  throttling, and database health.
- API-level rate limits and payload-size limits.
- Backups, restore exercise, and data-retention policy.
- Load test the initial target: 1,000 daily users, 50–100 concurrent users, 20 requests per
  second sustained, and short bursts to 50 requests per second.
- Deployment configuration, secrets, CORS policy, security review, and release runbook.

## 8. Performance Targets

These are initial targets to validate with tests, not guarantees.

| Area | Target |
|---|---|
| Catalog API p95 latency | Under 300 ms for indexed, database-only responses |
| Initial runtime | One API service, one PostgreSQL instance, one sync worker |
| Expected concurrency | 50–100 active users |
| Normal API load | 20 requests/second sustained, short bursts to 50 |
| Sync cadence | Every three hours after catalog seeding |
| Upstream request limit | Controlled shared budget, initial default of 2 requests/second |

We add Redis, multiple API instances, a queue, or a search engine only after measurement shows
that PostgreSQL and the existing process boundaries are insufficient.

## 9. Safety and Rollback Rules

- No client request should require a live MangaDex response for normal catalog browsing.
- A failed sync never deletes existing catalog data.
- A sync checkpoint advances only when its whole run completes successfully.
- SDUI updates are validated before publishing, scoped to client capabilities, revisioned,
  reversible, and auditable.
- A malformed or expired SDUI response falls back to a locally cached valid revision, then to a
  built-in essential screen.
- Schema migrations are backward-compatible where possible and tested before deployment.
- Upstream image bytes are never silently proxied through the metadata API.

## 10. Current Repository Map

| Path | Role |
|---|---|
| `Backend/` | Active FastAPI and PostgreSQL backend |
| `Backend/app/` | API, models, MangaDex client, importer, and worker code |
| `Backend/migrations/` | Database schema migrations |
| `Backend/tests/` | Backend automated tests |
| `frontend/` | Existing Flutter prototype; may be replaced during Milestone F |
| `docs/` | Original product and frontend documentation |
| `implementation_plan.md` | Historical Flutter-first plan; useful reference, no longer the active delivery plan |

## 11. Decisions Log

| Decision | Status | Rationale |
|---|---|---|
| Arabic and RTL first | Confirmed | Core target audience and product differentiator |
| Backend-first rebuild | Confirmed | Catalog reliability and future frontend independence |
| FastAPI + PostgreSQL | Confirmed | Clear, durable foundation for the initial scale |
| No chapter-image mirror initially | Confirmed | Avoid premature bandwidth and storage complexity |
| Three-hour metadata sync | Confirmed as initial target | Good freshness/cost compromise, subject to source rules |
| SDUI as a core platform capability | Confirmed | Remote updates for supported UI and feature behavior |
| BFF endpoints in the same FastAPI service first | Confirmed | Avoid unnecessary service separation before product evidence |
| Accounts and cloud progress | Deferred | Local first; add when cross-device needs are defined |

## 12. Immediate Next Work

Implement Milestone C:

1. Add sync-run persistence and operational status endpoints.
2. Define safe catalog partitioning for initial seed imports.
3. Build a resumable catalog seeder.
4. Implement the three-hour incremental worker and a conservative overlap window.
5. Add tests for partitions, checkpoint advancement, concurrent jobs, and upstream failure.

SDUI design begins after the catalog can provide enough stable data for realistic home and
discovery screens. We will define the schema before rebuilding the Flutter UI, so the client is
designed to render remote screen definitions from its first release.
