import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/manga_entity.dart';
import '../repositories/home_repository.dart';

import '../../../../core/usecases/usecase.dart';

@lazySingleton
class GetPopularMangaUseCase implements UseCase<List<MangaEntity>, PaginationParams> {
  final HomeRepository repository;

  GetPopularMangaUseCase(this.repository);

  @override
  Future<Either<Failure, List<MangaEntity>>> call(PaginationParams params) {
    return repository.getPopularManga(page: params.page, limit: params.limit);
  }
}
