import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/manga_entity.dart';
import '../repositories/home_repository.dart';

import '../../../../core/usecases/usecase.dart';

@lazySingleton
class GetTrendingMangaUseCase implements UseCase<List<MangaEntity>, PaginationParams> {
  final HomeRepository repository;

  GetTrendingMangaUseCase(this.repository);

  @override
  Future<Either<Failure, List<MangaEntity>>> call(PaginationParams params) {
    return repository.getTrendingManga(page: params.page, limit: params.limit);
  }
}
