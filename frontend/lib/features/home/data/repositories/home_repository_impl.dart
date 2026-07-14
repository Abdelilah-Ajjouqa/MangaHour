import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/manga_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/jikan_remote_data_source.dart';
import '../datasources/home_local_data_source.dart';
import '../models/manga_dto.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final JikanRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final AppDatabase appDatabase;

  HomeRepositoryImpl(this.remoteDataSource, this.localDataSource, this.appDatabase);

  Future<List<MangaEntity>> _processMangaDtos(List<MangaDto> dtos) async {
    // 1. Cache new Arabic titles
    for (var dto in dtos) {
      final entity = dto.toEntity();
      if (entity.arabicTitle != null) {
        await appDatabase.cacheArabicTitle(dto.malId, entity.arabicTitle!);
      }
    }

    // 2. Lookup missing Arabic titles
    final missingIds = dtos.where((d) => d.toEntity().arabicTitle == null).map((d) => d.malId).toList();
    final cachedTitles = await appDatabase.getArabicTitlesForIds(missingIds);

    // 3. Construct final entities
    return dtos.map((dto) {
      var entity = dto.toEntity();
      if (entity.arabicTitle == null && cachedTitles.containsKey(dto.malId)) {
        entity = entity.copyWith(arabicTitle: cachedTitles[dto.malId]);
      }
      return entity;
    }).toList();
  }

  @override
  Future<Either<Failure, List<MangaEntity>>> getPopularManga({int page = 1, int limit = 10}) async {
    try {
      final remoteManga = await remoteDataSource.getPopularManga(page: page, limit: limit);
      final entities = await _processMangaDtos(remoteManga);
      await localDataSource.cacheManga(entities, 'popular');
      return Right(entities);
    } on ServerException {
      return const Left(ServerFailure('تعذر الاتصال بالخادم، يرجى المحاولة لاحقاً'));
    }
  }

  @override
  Future<Either<Failure, List<MangaEntity>>> getTrendingManga({int page = 1, int limit = 10}) async {
    try {
      final remoteManga = await remoteDataSource.getTrendingManga(page: page, limit: limit);
      final entities = await _processMangaDtos(remoteManga);
      await localDataSource.cacheManga(entities, 'trending');
      return Right(entities);
    } on ServerException {
      return const Left(ServerFailure('تعذر الاتصال بالخادم، يرجى المحاولة لاحقاً'));
    }
  }

  @override
  Future<List<MangaEntity>> getOfflineManga() async {
    return await localDataSource.getAllCachedManga();
  }
}
