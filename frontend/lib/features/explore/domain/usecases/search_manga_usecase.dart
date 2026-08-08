import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/entities/manga_entity.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/explore_repository.dart';

@lazySingleton
class SearchMangaUseCase implements UseCase<List<MangaEntity>, String> {
  final ExploreRepository repository;

  SearchMangaUseCase(this.repository);

  @override
  Future<Either<Failure, List<MangaEntity>>> call(String params) {
    return repository.searchManga(params);
  }
}
