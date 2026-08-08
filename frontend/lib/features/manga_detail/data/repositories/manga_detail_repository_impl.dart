import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/safe_api_call.dart';
import '../../domain/entities/manga_detail_entity.dart';
import '../../domain/repositories/manga_detail_repository.dart';
import '../datasources/manga_detail_remote_data_source.dart';

@LazySingleton(as: MangaDetailRepository)
class MangaDetailRepositoryImpl with SafeApiCall implements MangaDetailRepository {
  final MangaDetailRemoteDataSource remoteDataSource;

  MangaDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MangaDetailEntity>> getMangaDetails(int id) async {
    return safeApiCall(() async {
      final remoteManga = await remoteDataSource.getMangaDetails(id);
      return remoteManga.toEntity();
    });
  }
}
