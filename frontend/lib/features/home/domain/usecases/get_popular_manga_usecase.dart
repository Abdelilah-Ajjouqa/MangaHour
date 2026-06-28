import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/manga_entity.dart';
import '../repositories/home_repository.dart';

@lazySingleton
class GetPopularMangaUseCase {
  final HomeRepository repository;

  GetPopularMangaUseCase(this.repository);

  Future<Either<Failure, List<MangaEntity>>> call({int page = 1, int limit = 10}) {
    return repository.getPopularManga(page: page, limit: limit);
  }
}
