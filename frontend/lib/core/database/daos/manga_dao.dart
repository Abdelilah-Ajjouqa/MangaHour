import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../app_database.dart';
import '../tables/cached_manga_table.dart';
import '../tables/arabic_titles_table.dart';

part 'manga_dao.g.dart';

@DriftAccessor(tables: [CachedMangaTable, ArabicTitlesTable])
@lazySingleton
class MangaDao extends DatabaseAccessor<AppDatabase> with _$MangaDaoMixin {
  MangaDao(super.db);

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
