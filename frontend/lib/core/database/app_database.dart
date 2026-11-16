import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'connection/connection.dart' as impl;
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
  AppDatabase() : super(impl.openConnection());

  @override
  int get schemaVersion => 1;
}
