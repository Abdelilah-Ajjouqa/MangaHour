# 04 — API Notes (MangaDex & Jikan)

This document outlines the two primary external APIs powering the application, including their core endpoints, rate-limiting rules, and architectural responsibilities.

---

## 1. Jikan API v4 (MyAnimeList) — Phase 1

**Role:** Provides manga metadata, discovery lists (trending/popular), and general information.
**Base URL:** `https://api.jikan.moe/v4/`

### Rate Limits (Strict)

- **Per Second Limit:** ≤ 3 requests.
- **Per Minute Limit:** ≤ 60 requests.
- **Interceptor Logic (`JikanRateLimiterInterceptor`):** Queues request timestamps, enforces artificial delays if limits are reached, and implements exponential backoff on `429 Too Many Requests` responses.

### Core Endpoints

- **Get Top Manga:** `GET /top/manga`
    - Fetches trending and popular manga.
    - Key Query params: `page`, `limit`, `filter` (`bypopularity` or `publishing`).
- **Search Manga:** `GET /manga`
    - Searches with filters.
    - Key Query params: `q`, `type` (manga/manhwa/manhua), `sfw=true` (Crucial for Arabic region filtering).
- **Get Full Details:** `GET /manga/{id}/full`
    - Retrieves full manga details using the MAL ID.
- **Get Characters:** `GET /manga/{id}/characters`
- **Get Recommendations:** `GET /manga/{id}/recommendations`

---

## 2. MangaDex API v5 — Phase 2

**Role:** Handles chapter reading, fetching raw/compressed image URLs, and prioritizing Arabic translations.
**Base URL:** `https://api.mangadex.org/`

### Rate Limits & Requirements

- **Per Second Limit:** ≤ 5 requests.
- **Required Headers:** `User-Agent: MangaReader/1.0` (Mandatory to comply with MangaDex TOS).

### Core Endpoints

- **ID Mapping (MAL to MangaDex):** `GET /manga`
    - Searches MangaDex by the external MyAnimeList ID.
    - Key Query param: `externalIds[mal][]={malId}`.
- **Get Chapter Feed:** `GET /manga/{id}/feed`
    - Fetches the chapter list for a resolved MangaDex UUID.
    - Key Query params: `translatedLanguage[]=ar`, `translatedLanguage[]=en` (Prioritizes Arabic, falls back to English), `order[chapter]=asc`.
- **Get Chapter Pages:** `GET /at-home/server/{chapterId}`
    - Retrieves the base URL and image hashes for the actual chapter pages.
    - Returns two quality tiers: `data` (high-quality original images) and `dataSaver` (compressed images to save bandwidth).
    - *Note: The response should be cached for 10 minutes and auto-refreshed on 403 errors.*