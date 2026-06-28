import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/manga_entity.dart';

abstract class HomeRepository {
  /// Fetches trending (currently publishing) manga
  Future<Either<Failure, List<MangaEntity>>> getTrendingManga({int page = 1, int limit = 10});

  /// Fetches all-time popular/top manga
  Future<Either<Failure, List<MangaEntity>>> getPopularManga({int page = 1, int limit = 10});
}
