# 00 — Vision & MVP Scope

<aside>

**Vision:** Build the fastest, most comfortable Arabic-first (RTL) manga/manhwa/manhua reader for Android & iOS — with a clean UX, great performance, and offline-friendly local data.

</aside>

## Why this app

- Current readers often treat Arabic as an afterthought (weak RTL, broken typography, bad navigation).
- Readers want a simple experience: search → open → read → continue, without friction.
- A backendless MVP can ship fast by relying on trusted external sources (MangaDex + Jikan) and storing user state locally.

## Product principles (non-negotiables)

- **Arabic first:** RTL everywhere (navigation, layouts, typography) + English as fallback.
- **Reader comfort:** paged + vertical modes; fast loading; predictable gestures.
- **Performance:** smooth scrolling, prefetching, caching; avoid heavy screens.
- **Privacy:** user data stays on-device for MVP (favorites/progress/cache).

## MVP scope (what “done” means)

A user can:

1. Browse/search titles (Arabic supported; English fallback).
2. Open a title details page (cover + synopsis + genres/tags).
3. Choose a chapter (prefer Arabic translations when available).
4. Read with **two modes**:
    - **Paged** (with RTL/LTR direction setting)
    - **Vertical** (continuous scroll)
5. Save reading progress automatically (last chapter + position).
6. Add/remove favorites (library).
7. Basic settings (language, reader mode, reading direction).
8. Handle errors gracefully (empty states, retry, rate limits).

## Non-goals (explicitly not in MVP)

- Accounts, sync across devices, cloud backup
- Social features (comments, sharing, community)
- Payments/subscriptions
- Recommendations engine (AI/ML)
- A custom backend (NestJS comes after MVP)

## Tech constraints (MVP)

- **Frontend:** Flutter (Clean Architecture + feature-first modular).
- **APIs:** MangaDex + Jikan only (no scraping).
- **Storage:** Drift or Isar (choose one early and stick to it).
- **Caching:** cache images/chapters to reduce data usage and improve speed.

## Success criteria

- RTL feels natural across the entire app (no “mirrored but wrong” UX).
- Reader stays smooth on mid-range Android devices.
- MVP is publishable and stable with real usage.