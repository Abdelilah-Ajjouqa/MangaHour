import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/safe_api_call.dart';
import '../../../../core/entities/manga_entity.dart';
import '../datasources/explore_remote_data_source.dart';
import '../../domain/repositories/explore_repository.dart';

@LazySingleton(as: ExploreRepository)
class ExploreRepositoryImpl with SafeApiCall implements ExploreRepository {
  final ExploreRemoteDataSource remoteDataSource;

  ExploreRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MangaEntity>>> searchManga(String query) async {
    return safeApiCall(() async {
      final remoteManga = await remoteDataSource.searchManga(query);
      return remoteManga.map((dto) => dto.toEntity()).toList();
    });
  }
}
