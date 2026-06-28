# MangaHour — Full Implementation Plan

> **Goal:** Build an Arabic-first (RTL) cross-platform manga/manhwa/manhua reader using Flutter, powered by MangaDex + Jikan APIs, with local storage for favorites, reading progress, and cache.

## Overview of Documentation Analyzed

All 17 docs in `C:\Projects\MangaHour\docs\` have been read and synthesized. The current Flutter project at `C:\Projects\MangaHour\frontend\` is a blank scaffold (default `main.dart`, no dependencies beyond Flutter SDK).

---

## User Decisions Confirmed

- **Project naming:** The Flutter project directory will remain `frontend`.
- **State Management:** **flutter_bloc** (Cubit + BLoC) will be used to pair perfectly with Clean Architecture.
- **Local DB:** **Drift** will be used for all local database requirements (caching, favorites, reading progress, title mappings).
- **App name / package ID:** The package name will be `com.mangahour.app` for Android and iOS.
- **UI Design:** We will start with a **Basic & Clean MVP Design** (dark mode, rounded rectangles, clean layout) in Phase 0. A Theme Engine will be added later for user customization. You will share screen-by-screen screenshots as we tackle each Phase.

---

## Proposed Architecture

```
lib/
├── app/                          # App-level wiring
│   ├── app.dart                  # MaterialApp.router, theme, localization
│   ├── router.dart               # GoRouter configuration
│   └── di/                       # Dependency injection setup
│       └── injection.dart        # get_it + injectable config
│
├── core/                         # Shared infrastructure
│   ├── constants/                # API URLs, cache durations, keys
│   ├── error/                    # Failure classes, exceptions
│   ├── network/                  # Dio client, interceptors
│   │   ├── dio_client.dart
│   │   ├── jikan_rate_limiter.dart
│   │   └── mangadex_interceptor.dart
│   ├── database/                 # Drift DB setup & tables
│   │   ├── app_database.dart
│   │   ├── tables/
│   │   │   ├── cached_manga_table.dart
│   │   │   ├── favorites_table.dart
│   │   │   ├── arabic_titles_table.dart
│   │   │   ├── id_mappings_table.dart
│   │   │   └── reading_progress_table.dart
│   │   └── daos/
│   ├── theme/                    # App theme (dark-first), colors, typography
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_typography.dart
│   ├── localization/             # ARB files, l10n config
│   │   ├── app_ar.arb
│   │   └── app_en.arb
│   ├── utils/                    # Helpers (debouncer, date formatting, etc.)
│   ├── widgets/                  # Shared reusable widgets
│   │   ├── manga_card.dart
│   │   ├── error_widget.dart
│   │   ├── loading_shimmer.dart
│   │   └── cached_cover_image.dart
│   └── extensions/               # Dart extensions
│
├── features/                     # Feature-first modules
│   ├── home/                     # Home / Discovery
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/           # DTOs (Jikan response models)
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/     # Abstract repo interfaces
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── search/                   # Search & filters
│   │   ├── data/ → domain/ → presentation/
│   │
│   ├── manga_detail/             # Title details + chapter list
│   │   ├── data/ → domain/ → presentation/
│   │
│   ├── reader/                   # Chapter reader (paged + vertical)
│   │   ├── data/ → domain/ → presentation/
│   │
│   ├── library/                  # Favorites + continue reading
│   │   ├── data/ → domain/ → presentation/
│   │
│   └── settings/                 # Language, reader prefs, cache
│       ├── data/ → domain/ → presentation/
│
└── main.dart                     # Entry point
```

---

## Phased Implementation Plan

### Phase 0 — Project Scaffolding & Core Infrastructure
> **Goal:** Set up the project skeleton, dependencies, DI, networking, database, theming, localization, and routing. No features yet — just the foundation.

#### Tasks

| # | Task | Details |
|---|------|---------|
| 0.1 | **Configure project** | Set package name to `com.mangahour.app`, update `pubspec.yaml` with all dependencies |
| 0.2 | **Create folder structure** | Scaffold the full `lib/` directory tree as shown above |
| 0.3 | **Add all dependencies** | `flutter_bloc`, `go_router`, `get_it`, `injectable`, `injectable_generator`, `dio`, `drift`, `drift_dev`, `build_runner`, `freezed`, `freezed_annotation`, `json_annotation`, `json_serializable`, `cached_network_image`, `flutter_cache_manager`, `flutter_localizations`, `intl`, `equatable`, `dartz` (or `fpdart`), `connectivity_plus` |
| 0.4 | **Dependency Injection** | Configure `get_it` + `injectable` with `@module`, `@singleton`, `@lazySingleton` |
| 0.5 | **Dio client + interceptors** | Create base Dio client, `JikanRateLimiterInterceptor` (3/s, 60/min), `MangaDexInterceptor` (5/s, User-Agent header), error interceptor |
| 0.6 | **Drift database** | Define all 5 tables (`CachedManga`, `Favorites`, `ArabicTitles`, `IdMappings`, `ReadingProgress`), create DAOs, run code generation |
| 0.7 | **Theming** | Basic & Clean MVP Design (dark-first theme, rounded rectangles, clean layout), RTL-aware typography (Arabic font: Noto Kufi Arabic or Cairo; Latin: Inter), color palette |
| 0.8 | **Localization (l10n)** | Set up `flutter_localizations`, Arabic ARB (default) + English ARB, configure `MaterialApp` with `supportedLocales`, `localizationsDelegates`, `locale` |
| 0.9 | **GoRouter setup** | Define route constants, create shell route with bottom navigation, placeholder pages for each feature |
| 0.10 | **Error handling foundation** | `Failure` sealed class, `ServerException`, `CacheException`, network connectivity check utility |
| 0.11 | **Shared widgets** | `MangaCard`, `ErrorRetryWidget`, `LoadingShimmer`, `CachedCoverImage` (placeholders, refined per feature) |

---

### Phase 1 — Home & Discovery (Jikan API)
> **Goal:** User opens the app → sees trending/popular manga on the Home Screen.

#### Tasks

| # | Task | Details |
|---|------|---------|
| 1.1 | **Jikan data source** | `JikanRemoteDataSource` — `getTopManga(filter, page, limit)`, `getMangaDetails(malId)` |
| 1.2 | **DTOs & Mappers** | Jikan JSON → `MangaDto` → `MangaEntity` (using `freezed` + `json_serializable`) |
| 1.3 | **Home repository** | `HomeRepository` (abstract) + `HomeRepositoryImpl` (cache-first: check `CachedManga` freshness → fetch remote → update cache) |
| 1.4 | **Use cases** | `GetTrendingMangaUseCase`, `GetPopularMangaUseCase` |
| 1.5 | **Home BLoC** | `HomeBloc` — states: Initial, Loading, Loaded(trending, popular), Error |
| 1.6 | **Home Screen UI** | Horizontal carousels for trending/popular, `MangaCard` widgets, pull-to-refresh — **(UI design needed here)** |
| 1.7 | **Arabic title caching** | Store Arabic titles in `ArabicTitles` table when available from Jikan response |

---

### Phase 2 — Search & Filtering (Jikan API)
> **Goal:** User can search for manga by title and filter by type.

| # | Task | Details |
|---|------|---------|
| 2.1 | **Search data source** | `searchManga(query, type, page)` with `sfw=true` |
| 2.2 | **Search repository** | Implements debounced remote search |
| 2.3 | **Search BLoC** | Debounced text input → search results, filter chips (manga/manhwa/manhua) |
| 2.4 | **Search Screen UI** | Search bar, filter chips, results grid — **(UI design needed)** |

---

### Phase 3 — Manga Detail & Chapter List (Jikan + MangaDex)
> **Goal:** User taps a manga → sees full details → taps "Read Chapters" → sees chapter list with Arabic priority.

| # | Task | Details |
|---|------|---------|
| 3.1 | **Detail data source (Jikan)** | `getMangaFullDetails(malId)` |
| 3.2 | **ID Mapping service** | Check `IdMappings` cache → if miss, call MangaDex `GET /manga?externalIds[mal][]={malId}` → save mapping |
| 3.3 | **Chapter feed data source (MangaDex)** | `getChapterFeed(mangadexId, languages: [ar, en])` |
| 3.4 | **Chapter grouping logic** | Group by chapter number, prioritize Arabic, badge English-only chapters |
| 3.5 | **Detail BLoC** | Load manga details + resolve ID mapping + fetch chapters |
| 3.6 | **Detail Screen UI** | Cover image, title (AR/EN), synopsis, genres, "Read Chapters" CTA — **(UI design needed)** |
| 3.7 | **Chapter List Screen UI** | Grouped chapter list, language badges, scroll to last-read — **(UI design needed)** |

---

### Phase 4 — Reader (MangaDex)
> **Goal:** User reads chapters in paged (RTL/LTR) or vertical (scroll) mode with auto-save.

| # | Task | Details |
|---|------|---------|
| 4.1 | **Chapter pages data source** | `getChapterPages(chapterId)` via `GET /at-home/server/{chapterId}`, cache base URL for 10 min |
| 4.2 | **Image URL builder** | Construct full image URLs from base URL + hash + filename, support `data` and `dataSaver` quality tiers |
| 4.3 | **MangaCacheManager** | Custom `CacheManager` — 2000 objects max, 14-day stale period |
| 4.4 | **Reader BLoC** | Load pages, track current page, handle mode switching, debounced progress save (2s) |
| 4.5 | **Paged reader widget** | `PageView` with RTL/LTR support, tap zones (left/center/right), prefetch adjacent pages |
| 4.6 | **Vertical reader widget** | `ScrollView` with continuous scroll, lazy image loading, prefetch |
| 4.7 | **Reader overlay** | Chapter nav, page slider, settings toggle, auto-hide on tap |
| 4.8 | **Reading progress** | Debounced auto-save to `ReadingProgress` table, forced save on exit/chapter-complete |
| 4.9 | **Reader Screen UI** | Full-screen immersive reader — **(UI design needed)** |

---

### Phase 5 — Library / Favorites
> **Goal:** User can add/remove favorites and resume reading from where they left off.

| # | Task | Details |
|---|------|---------|
| 5.1 | **Favorites repository** | CRUD on `Favorites` table, sort order support |
| 5.2 | **Library BLoC** | Load favorites, toggle favorite, reorder |
| 5.3 | **Continue Reading widget** | Query `ReadingProgress` → show "Continue Reading" cards with progress indicator |
| 5.4 | **Library Screen UI** | Favorites grid + continue reading section — **(UI design needed)** |

---

### Phase 6 — Settings
> **Goal:** User can switch language, reader mode, reading direction, and manage cache.

| # | Task | Details |
|---|------|---------|
| 6.1 | **Settings repository** | SharedPreferences-based storage for user preferences |
| 6.2 | **Settings BLoC** | Language switch (ar/en), default reader mode (paged/vertical), default direction (RTL/LTR), clear cache |
| 6.3 | **Settings Screen UI** | Grouped settings list — **(UI design needed)** |

---

### Phase 7 — Polish & QA
> **Goal:** Error states, edge cases, performance, and release readiness.

| # | Task | Details |
|---|------|---------|
| 7.1 | **Error states** | Empty states for search (no results), network errors (retry), rate limit handling (429 backoff) |
| 7.2 | **History feature** | (Medium priority) Track recently opened titles/chapters |
| 7.3 | **RTL audit** | Full walkthrough of every screen in Arabic mode, fix any mirroring issues |
| 7.4 | **Performance** | Memory profiling (Reader screen), image prefetch tuning, scroll jank fixes |
| 7.5 | **QA checklist** | Execute all items from [07 — QA & Release checklist](file:///C:/Projects/MangaHour/docs/07%20—%20QA%20&%20Release%20checklist%202a1797015a864a8ebb315ec51533dc48.md) |

---

## Verification Plan

### Automated Tests
- **Unit tests:** Use cases, BLoCs, repositories (with mocked data sources)
- **Widget tests:** Key screens with golden tests for RTL layout verification
- **Command:** `flutter test`

### Manual Verification
- Full RTL walkthrough (Arabic only)
- Language switch mid-session (AR → EN → AR)
- Reader stress test (50+ page chapter, rapid scroll, pinch-zoom)
- ID mapping verification (10 popular titles)
- Arabic chapter priority check
- Offline behavior (airplane mode with cached data)
- Memory profiling via DevTools
- iOS testing on simulator/device

---

## Execution Strategy

We start with **Phase 0** (scaffolding + infrastructure). This is the critical foundation — every feature depends on it. Once Phase 0 is complete and verified, we proceed feature-by-feature (Phases 1–6), with you providing the UI design for each screen as we reach it. Phase 7 runs as a final pass.
