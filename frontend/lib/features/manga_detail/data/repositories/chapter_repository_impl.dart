import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/daos/id_mappings_dao.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/safe_api_call.dart';
import '../../domain/entities/chapter_entity.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../datasources/mangadex_remote_data_source.dart';

@LazySingleton(as: ChapterRepository)
class ChapterRepositoryImpl with SafeApiCall implements ChapterRepository {
  final MangaDexRemoteDataSource remoteDataSource;
  final IdMappingsDao idMappingsDao;

  ChapterRepositoryImpl(this.remoteDataSource, this.idMappingsDao);

  @override
  Future<Either<Failure, String?>> getMangaDexId({
    required int malId,
    required String title,
  }) async {
    return safeApiCall(() async {
      // 1. Check local cache in Drift
      final cachedId = await idMappingsDao.getMangadexId(malId);
      if (cachedId != null && cachedId.isNotEmpty) {
        return cachedId;
      }

      // 2. Query MangaDex API
      final remoteId = await remoteDataSource.searchMangaDexId(
        title: title,
        malId: malId,
      );

      // 3. Cache if found
      if (remoteId != null && remoteId.isNotEmpty) {
        await idMappingsDao.saveMapping(malId, remoteId);
      }

      return remoteId;
    });
  }

  @override
  Future<Either<Failure, List<ChapterEntity>>> getChapters({
    required int malId,
    required String title,
  }) async {
    return safeApiCall(() async {
      final idResult = await getMangaDexId(malId: malId, title: title);
      final mangadexId = idResult.fold((l) => null, (r) => r);

      if (mangadexId == null || mangadexId.isEmpty) {
        return <ChapterEntity>[];
      }

      final chapterDtos = await remoteDataSource.getChapterFeed(
        mangadexId: mangadexId,
      );

      // Group chapters by chapterString to prioritize Arabic over English
      final Map<String, ChapterEntity> chapterMap = {};

      for (final dto in chapterDtos) {
        final entity = dto.toEntity();
        final key = entity.chapterString;

        if (!chapterMap.containsKey(key)) {
          chapterMap[key] = entity;
        } else {
          // If existing is not Arabic and current is Arabic, replace it!
          final existing = chapterMap[key]!;
          if (!existing.isArabic && entity.isArabic) {
            chapterMap[key] = entity;
          }
        }
      }

      final chapters = chapterMap.values.toList();

      // Sort chapters numerically ascending
      chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));

      return chapters;
    });
  }
}
