# 05 — Data & Local Storage (Favorites/Progress/Cache)

The application uses **Drift (formerly Moor)** as a high-performance, type-safe local SQLite database to handle offline caching, user favorites, and reading progress.

## Database Schema (Tables)

The `AppDatabase` consists of the following core tables:

1. **`CachedManga`**:
    - Stores manga metadata fetched from Jikan (MAL).
    - **Cache Rule:** Considered fresh for 24 hours. After 24 hours, the app fetches new data and updates the cache.
2. **`Favorites`**:
    - Stores the user's saved manga.
    - Data is kept purely local in Phase 1 & 2 (no cloud sync).
3. **`ArabicTitles`**:
    - Stores the Arabic localized titles.
    - Acts as a persistent cache to avoid re-translating titles when switching locales.
4. **`IdMappings`**:
    - Stores the bridge connection mapping a `malId` to a `mangadexId`.
5. **`ReadingProgress`**:
    - Tracks exactly where the user left off.
    - Stores `lastChapterId`, `lastPageIndex`, `totalPages`, and `isCompleted`.

## Core Storage Mechanisms

### 1. Reading Progress Auto-Save

To prevent excessive database writes while the user rapidly swipes through pages, the app uses a **Debounced Auto-Save** strategy:

- Progress is only saved to the database **2 seconds** after the user stops turning pages.
- A forced immediate save occurs when the user exits the reader or finishes the chapter.

### 2. Image Caching (Reader)

- Handled by `flutter_cache_manager` (specifically `MangaCacheManager`).
- **Limits:** Configured to hold up to 2000 image objects with a 14-day stale period to optimize disk space and reduce bandwidth.