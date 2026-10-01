import 'package:dartz/dartz.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';

abstract class ReadingProgressRepository {
  Future<Either<Failure, void>> saveProgress({
    required int malId,
    required String mangadexId,
    required String chapterId,
    required String chapterTitle,
    required int lastReadPage,
    required int totalPages,
  });

  Future<Either<Failure, ReadingProgressTableData?>> getProgress(
    String mangadexId,
  );
  Future<Either<Failure, List<ReadingProgressTableData>>> getAllHistory();
}
