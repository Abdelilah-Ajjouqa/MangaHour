import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/manga_entity.dart';
import '../repositories/home_repository.dart';

@lazySingleton
class GetTrendingMangaUseCase {
  final HomeRepository repository;

  GetTrendingMangaUseCase(this.repository);

  Future<Either<Failure, List<MangaEntity>>> call({int page = 1, int limit = 10}) {
    return repository.getTrendingManga(page: page, limit: limit);
  }
}
