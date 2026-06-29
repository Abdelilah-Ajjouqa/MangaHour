import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'tables/cached_manga_table.dart';
import 'tables/favorites_table.dart';
import 'tables/arabic_titles_table.dart';
import 'tables/id_mappings_table.dart';
import 'tables/reading_progress_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  CachedMangaTable,
  FavoritesTable,
  ArabicTitlesTable,
  IdMappingsTable,
  ReadingProgressTable,
])
@lazySingleton
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> cacheArabicTitle(int id, String title) async {
    await into(arabicTitlesTable).insertOnConflictUpdate(
      ArabicTitlesTableData(malId: id, arabicTitle: title),
    );
  }

  Future<Map<int, String>> getArabicTitlesForIds(List<int> malIds) async {
    if (malIds.isEmpty) return {};
    final query = select(arabicTitlesTable)..where((t) => t.malId.isIn(malIds));
    final results = await query.get();
    return {for (var r in results) r.malId: r.arabicTitle};
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'mangahour_db.sqlite'));

    // Database file location

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 tries to use.
    // Tell it to use the app's cache directory instead.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
