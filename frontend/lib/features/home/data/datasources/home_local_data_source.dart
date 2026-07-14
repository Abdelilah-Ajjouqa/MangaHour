import 'package:drift/drift.dart' as drift;
import 'package:injectable/injectable.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/manga_entity.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheManga(List<MangaEntity> mangas, String cacheKey);
  Future<List<MangaEntity>> getCachedManga(String cacheKey);
  Future<List<MangaEntity>> getAllCachedManga();
}

@LazySingleton(as: HomeLocalDataSource)
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final AppDatabase appDatabase;

  HomeLocalDataSourceImpl(this.appDatabase);

  @override
  Future<void> cacheManga(List<MangaEntity> mangas, String cacheKey) async {
    final companions = mangas.map((m) => CachedMangaTableCompanion.insert(
      malId: m.malId,
      title: m.title,
      imageUrl: m.coverUrl,
      type: 'manga',
      score: drift.Value(m.score),
      lastUpdated: DateTime.now(),
      cacheKey: cacheKey,
    )).toList();

    await appDatabase.cacheMangaList(companions, cacheKey);
    
    // Also cache the Arabic titles since it's a separate table
    for (var m in mangas) {
      if (m.arabicTitle != null) {
        await appDatabase.cacheArabicTitle(m.malId, m.arabicTitle!);
      }
    }
  }

  @override
  Future<List<MangaEntity>> getCachedManga(String cacheKey) async {
    final cachedData = await appDatabase.getCachedManga(cacheKey);
    return _mapToEntities(cachedData);
  }

  @override
  Future<List<MangaEntity>> getAllCachedManga() async {
    final cachedData = await appDatabase.getAllCachedManga();
    
    // Remove duplicates based on malId if they exist in multiple cache keys
    final uniqueMap = <int, CachedMangaTableData>{};
    for (var data in cachedData) {
      uniqueMap[data.malId] = data;
    }
    return _mapToEntities(uniqueMap.values.toList());
  }

  Future<List<MangaEntity>> _mapToEntities(List<CachedMangaTableData> cachedData) async {
    if (cachedData.isEmpty) return [];

    final malIds = cachedData.map((e) => e.malId).toList();
    final arabicTitles = await appDatabase.getArabicTitlesForIds(malIds);

    return cachedData.map((data) => MangaEntity(
      malId: data.malId,
      title: data.title,
      arabicTitle: arabicTitles[data.malId],
      coverUrl: data.imageUrl,
      score: data.score ?? 0.0,
      isPublishing: false, // Defaulting to false for offline cache
    )).toList();
  }
}
