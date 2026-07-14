import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/manga_detail_entity.dart';
import '../../domain/repositories/manga_detail_repository.dart';
import '../datasources/manga_detail_remote_data_source.dart';

@LazySingleton(as: MangaDetailRepository)
class MangaDetailRepositoryImpl implements MangaDetailRepository {
  final MangaDetailRemoteDataSource remoteDataSource;

  MangaDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MangaDetailEntity>> getMangaDetails(int id) async {
    try {
      final remoteManga = await remoteDataSource.getMangaDetails(id);
      return Right(remoteManga.toEntity());
    } on ServerException {
      return const Left(ServerFailure('تعذر الاتصال بالخادم، يرجى المحاولة لاحقاً'));
    }
  }
}
