import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/manga_detail_entity.dart';

abstract class MangaDetailRepository {
  Future<Either<Failure, MangaDetailEntity>> getMangaDetails(int id);
}
