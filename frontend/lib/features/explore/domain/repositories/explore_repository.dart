import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/manga_entity.dart';

abstract class ExploreRepository {
  Future<Either<Failure, List<MangaEntity>>> searchManga(String query);
}
