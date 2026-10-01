import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/safe_api_call.dart';
import '../../domain/repositories/reader_repository.dart';
import '../datasources/reader_remote_data_source.dart';

@LazySingleton(as: ReaderRepository)
class ReaderRepositoryImpl with SafeApiCall implements ReaderRepository {
  final ReaderRemoteDataSource remoteDataSource;

  ReaderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<String>>> getChapterPages(
    String chapterId, {
    bool useDataSaver = false,
  }) async {
    return safeApiCall(() async {
      final atHome = await remoteDataSource.getChapterAtHome(chapterId);
      return atHome.getPageUrls(useDataSaver: useDataSaver);
    });
  }
}
