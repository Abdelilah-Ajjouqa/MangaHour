import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/manga_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/jikan_remote_data_source.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final JikanRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MangaEntity>>> getPopularManga({int page = 1, int limit = 10}) async {
    try {
      final remoteManga = await remoteDataSource.getPopularManga(page: page, limit: limit);
      return Right(remoteManga.map((dto) => dto.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure('Failed to fetch popular manga from server'));
    }
  }

  @override
  Future<Either<Failure, List<MangaEntity>>> getTrendingManga({int page = 1, int limit = 10}) async {
    try {
      final remoteManga = await remoteDataSource.getTrendingManga(page: page, limit: limit);
      return Right(remoteManga.map((dto) => dto.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure('Failed to fetch trending manga from server'));
    }
  }
}
