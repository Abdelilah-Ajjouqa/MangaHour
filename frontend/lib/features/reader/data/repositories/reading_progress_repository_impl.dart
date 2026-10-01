import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/reading_progress_dao.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/safe_api_call.dart';
import '../../domain/repositories/reading_progress_repository.dart';

@LazySingleton(as: ReadingProgressRepository)
class ReadingProgressRepositoryImpl
    with SafeApiCall
    implements ReadingProgressRepository {
  final ReadingProgressDao readingProgressDao;

  ReadingProgressRepositoryImpl(this.readingProgressDao);

  @override
  Future<Either<Failure, void>> saveProgress({
    required int malId,
    required String mangadexId,
    required String chapterId,
    required String chapterTitle,
    required int lastReadPage,
    required int totalPages,
  }) async {
    return safeApiCall(() async {
      final companion = ReadingProgressTableCompanion(
        malId: Value(malId),
        mangadexId: Value(mangadexId),
        chapterId: Value(chapterId),
        chapterTitle: Value(chapterTitle),
        lastReadPage: Value(lastReadPage),
        totalPages: Value(totalPages),
        lastReadAt: Value(DateTime.now()),
      );
      await readingProgressDao.saveProgress(companion);
    });
  }

  @override
  Future<Either<Failure, ReadingProgressTableData?>> getProgress(
    String mangadexId,
  ) async {
    return safeApiCall(() {
      return readingProgressDao.getProgress(mangadexId);
    });
  }

  @override
  Future<Either<Failure, List<ReadingProgressTableData>>>
  getAllHistory() async {
    return safeApiCall(() {
      return readingProgressDao.getAllHistory();
    });
  }
}
