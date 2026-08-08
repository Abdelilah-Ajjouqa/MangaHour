import 'package:drift/drift.dart' as drift;
import 'package:injectable/injectable.dart';
import '../../../../core/database/daos/cached_manga_dao.dart';
import '../../../../core/database/daos/arabic_titles_dao.dart';
import '../../../../core/database/app_database.dart' show CachedMangaTableCompanion, CachedMangaTableData;
import '../../../../core/entities/manga_entity.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheManga(List<MangaEntity> mangas, String cacheKey);
  Future<List<MangaEntity>> getCachedManga(String cacheKey);
  Future<List<MangaEntity>> getAllCachedManga();
}

@LazySingleton(as: HomeLocalDataSource)
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final CachedMangaDao cachedMangaDao;
  final ArabicTitlesDao arabicTitlesDao;

  HomeLocalDataSourceImpl(this.cachedMangaDao, this.arabicTitlesDao);

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

    await cachedMangaDao.cacheMangaList(companions, cacheKey);
    
    for (var m in mangas) {
      if (m.arabicTitle != null) {
        await arabicTitlesDao.cacheArabicTitle(m.malId, m.arabicTitle!);
      }
    }
  }

  @override
  Future<List<MangaEntity>> getCachedManga(String cacheKey) async {
    final cachedData = await cachedMangaDao.getCachedManga(cacheKey);
    return _mapToEntities(cachedData);
  }

  @override
  Future<List<MangaEntity>> getAllCachedManga() async {
    final cachedData = await cachedMangaDao.getAllCachedManga();
    
    final uniqueMap = <int, CachedMangaTableData>{};
    for (var data in cachedData) {
      uniqueMap[data.malId] = data;
    }
    return _mapToEntities(uniqueMap.values.toList());
  }

  Future<List<MangaEntity>> _mapToEntities(List<CachedMangaTableData> cachedData) async {
    if (cachedData.isEmpty) return [];

    final malIds = cachedData.map((e) => e.malId).toList();
    final arabicTitles = await arabicTitlesDao.getArabicTitlesForIds(malIds);

    return cachedData.map((data) => MangaEntity(
      malId: data.malId,
      title: data.title,
      arabicTitle: arabicTitles[data.malId],
      coverUrl: data.imageUrl,
      score: data.score ?? 0.0,
      isPublishing: false,
    )).toList();
  }
}
