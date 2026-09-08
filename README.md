# MangaHour
A high-performance, Arabic & RTL-first cross-platform Manga, Manhwa, and Manhua reader for Android and iOS built with Flutter.

---

## Quick Setup Guide

If you just cloned the repository, the frontend requires dependency installation and code generation before running or analyzing.

### Steps:
```bash
# 1. Navigate to frontend directory
cd frontend

# 2. Fetch Flutter packages
flutter pub get

# 3. Generate localization files
flutter gen-l10n

# 4. Generate models, database, and dependency injection files
dart run build_runner build

# 5. Check project health
flutter analyze
```

For more details, refer to the [frontend README](frontend/README.md).
