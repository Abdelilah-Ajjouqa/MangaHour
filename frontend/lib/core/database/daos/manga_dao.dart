import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../app_database.dart';
import '../tables/cached_manga_table.dart';
import '../tables/arabic_titles_table.dart';

import '../tables/favorites_table.dart';

part 'manga_dao.g.dart';

@DriftAccessor(tables: [CachedMangaTable, ArabicTitlesTable, FavoritesTable])
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

  // --- Favorites Logic ---
  
  Future<void> addFavorite(FavoritesTableCompanion favorite) async {
    await into(favoritesTable).insertOnConflictUpdate(favorite);
  }

  Future<void> removeFavorite(int malId) async {
    await (delete(favoritesTable)..where((t) => t.malId.equals(malId))).go();
  }

  Future<bool> isFavorite(int malId) async {
    final query = select(favoritesTable)..where((t) => t.malId.equals(malId));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<List<FavoritesTableData>> getFavorites() async {
    final query = select(favoritesTable)..orderBy([(t) => OrderingTerm(expression: t.addedAt, mode: OrderingMode.desc)]);
    return await query.get();
  }
}
