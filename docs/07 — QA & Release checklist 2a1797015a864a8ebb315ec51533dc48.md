# 07 — QA & Release checklist

Before any major release, the application must pass this strict manual verification plan to ensure platform stability (especially on iOS) and full RTL compliance.

## Manual Verification Steps

- [ ]  **Full RTL Walkthrough:** Navigate through every screen and interaction ensuring the Arabic-only UI does not break or misalign.
- [ ]  **Language Switch Mid-Session:** Toggle between Arabic → English → Arabic without crashing or breaking the layout.
- [ ]  **Reader Performance (Stress Test):** Open a 50+ page chapter, perform rapid scrolling, and pinch-zoom. Ensure there is no jank and no Out-Of-Memory (OOM) crashes on iOS.
- [ ]  **ID Mapping Verification:** Verify that 10 popular manga titles correctly map from MAL (Jikan) to MangaDex.
- [ ]  **Arabic Chapter Priority:** Confirm Arabic chapters are shown by default when available, and English fallback chapters are visible with the correct badge.
- [ ]  **Offline Behavior:** Turn on airplane mode with cached data available. Verify the app shows graceful error states without crashing.
- [ ]  **Memory Profiling:** Check the DevTools memory tab to ensure there are no memory leaks after exiting the Reader screen.
- [ ]  **iOS Testing:** Verify all features work identically and smoothly on iOS.