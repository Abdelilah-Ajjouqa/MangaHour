import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/chapter_entity.dart';

abstract class ChapterRepository {
  Future<Either<Failure, List<ChapterEntity>>> getChapters({
    required int malId,
    required String title,
  });

  Future<Either<Failure, String?>> getMangaDexId({
    required int malId,
    required String title,
  });
}
