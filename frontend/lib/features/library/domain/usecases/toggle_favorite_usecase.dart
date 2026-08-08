import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/entities/manga_entity.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

@lazySingleton
class ToggleFavoriteUseCase implements UseCase<void, MangaEntity> {
  final FavoritesRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MangaEntity params) async {
    final isFav = await repository.isFavorite(params.malId);
    return isFav.fold(
      (failure) => Left(failure),
      (isFavorite) async {
        if (isFavorite) {
          return await repository.removeFavorite(params.malId);
        } else {
          return await repository.addFavorite(params);
        }
      },
    );
  }
}
