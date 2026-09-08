# MangaHour (Frontend)

A high-performance, RTL-first Manga, Manhwa, and Manhua reader application built with Flutter.

---

## Getting Started

This project relies on **code generation** for Freezed models, Drift local database tables/DAOs, JSON serialization, and Injectable dependency injection. Because generated files (`*.freezed.dart`, `*.g.dart`, `*.config.dart`) are not committed to source control, you **must** generate them after cloning or pulling changes.

### First-Time Setup

Run the following commands from the `frontend/` directory:

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate Localization Files**
   ```bash
   flutter gen-l10n
   ```

3. **Generate Code (Freezed, Drift, Injectable, JSON Serializer)**
   ```bash
   dart run build_runner build
   ```

4. **Verify Project Health**
   ```bash
   flutter analyze
   ```

Once these steps complete, the project is fully set up and ready to run!

---

## Development Workflow

### Continuous Code Generation
While developing features that modify models, database tables, or injectable singletons, keep the build runner active in watch mode so files update automatically:
```bash
dart run build_runner watch
```

---

## Troubleshooting

### Why are there 100+ `flutter analyze` errors after cloning?
If you run `flutter analyze` immediately without running code generation, you will encounter errors such as:
- `Target of URI doesn't exist: '...freezed.dart'`
- `Target of URI hasn't been generated: '...g.dart'`
- `Undefined name 'malId'` or missing getters in DTOs
- `The method 'FavoritesTableCompanion' isn't defined`

**Solution**: Simply run `dart run build_runner build`. It generates all the missing classes and companions, resolving all analyzer errors.
