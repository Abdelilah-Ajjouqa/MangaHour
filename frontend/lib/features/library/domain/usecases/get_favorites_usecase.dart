import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/entities/manga_entity.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

@lazySingleton
class GetFavoritesUseCase implements UseCase<List<MangaEntity>, NoParams> {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MangaEntity>>> call(NoParams params) async {
    return await repository.getFavorites();
  }
}
