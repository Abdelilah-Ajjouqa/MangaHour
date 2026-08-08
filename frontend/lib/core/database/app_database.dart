import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import 'daos/cached_manga_dao.dart';
import 'daos/arabic_titles_dao.dart';
import 'daos/favorites_dao.dart';
import 'daos/reading_progress_dao.dart';
import 'daos/id_mappings_dao.dart';

import 'tables/cached_manga_table.dart';
import 'tables/favorites_table.dart';
import 'tables/arabic_titles_table.dart';
import 'tables/id_mappings_table.dart';
import 'tables/reading_progress_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CachedMangaTable,
    FavoritesTable,
    ArabicTitlesTable,
    IdMappingsTable,
    ReadingProgressTable,
  ],
  daos: [
    CachedMangaDao,
    ArabicTitlesDao,
    FavoritesDao,
    ReadingProgressDao,
    IdMappingsDao,
  ],
)
@lazySingleton
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'mangahour_db.sqlite'));

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
