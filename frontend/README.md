# MangaHour

A high-performance, RTL-first Manga, Manhwa, and Manhua reader application.

## Getting Started

Because this project relies heavily on code generation for localization, dependency injection, and the database, you must run a few commands after cloning the project for the first time.

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate Localization Files**
   ```bash
   flutter gen-l10n
   ```

3. **Generate Code (.g.dart, .config.dart)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

After running these three commands, your project will be fully set up and ready to run!
