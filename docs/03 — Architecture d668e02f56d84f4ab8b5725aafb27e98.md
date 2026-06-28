# 03 — Architecture

## High-level

- Flutter app (Clean Architecture + feature-first)
- External APIs: MangaDex + Jikan
- Local storage: Drift or Isar
- No custom backend for MVP

## Modules (suggested)

- core (networking, errors, localization)
- features/search
- features/title_details
- features/reader
- features/library
- features/settings

## Diagrams (add)

```mermaid
flowchart LR
	A[Flutter App] --> B[MangaDex API]
	A --> C[Jikan API]
	A --> D[Local DB (Drift/Isar)]
	A --> E[Image cache]
```