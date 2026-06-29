# MangaHour Agent Rules

These rules must be respected by all AI agents working in this workspace across all conversations:

## 1. DRY (Don't Repeat Yourself)
- **Rule:** Never duplicate code. Always extract duplicated UI elements into reusable components in `lib/core/widgets`. Extract duplicated logic into shared helpers or use cases.
- **Reason:** The project will become highly complex in the future. Features like **AI Insta-Translate** and **Dynamic Theming** (Cyberpunk, Forest, Old, etc.) will be added. Hardcoded or duplicated widgets will make these features impossible to implement scalably. Always build with maximum reusability in mind.

## 2. Lazy Loading (Pagination)
- **Rule:** All lists and data fetches must support lazy loading / pagination to conserve resources.
- **Reason:** The Jikan and MangaDex APIs have strict rate limits. Fetching all data at once will crash the app and trigger rate limits. 
- **Implementation:** For horizontal carousels on the home screen, fetch a small preview list (e.g., top 10) and use a "View All" button to route to a dedicated screen with full infinite scrolling.
