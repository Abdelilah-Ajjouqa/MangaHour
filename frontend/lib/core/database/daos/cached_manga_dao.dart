import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../app_database.dart';
import '../tables/cached_manga_table.dart';

part 'cached_manga_dao.g.dart';

@DriftAccessor(tables: [CachedMangaTable])
@lazySingleton
class CachedMangaDao extends DatabaseAccessor<AppDatabase> with _$CachedMangaDaoMixin {
  CachedMangaDao(super.db);

  Future<void> cacheMangaList(List<CachedMangaTableCompanion> mangaList, String cacheKey) async {
    return transaction(() async {
      await (delete(cachedMangaTable)..where((t) => t.cacheKey.equals(cacheKey))).go();
      await batch((batch) {
        batch.insertAll(cachedMangaTable, mangaList);
      });
    });
  }

  Future<List<CachedMangaTableData>> getCachedManga(String cacheKey) async {
    return (select(cachedMangaTable)..where((t) => t.cacheKey.equals(cacheKey))).get();
  }

  Future<List<CachedMangaTableData>> getAllCachedManga() async {
    return select(cachedMangaTable).get();
  }
}
