import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class ReaderRepository {
  Future<Either<Failure, List<String>>> getChapterPages(
    String chapterId, {
    bool useDataSaver = false,
  });
}
