import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entities/manga_entity.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, void>> addFavorite(MangaEntity manga);
  Future<Either<Failure, void>> removeFavorite(int malId);
  Future<Either<Failure, bool>> isFavorite(int malId);
  Future<Either<Failure, List<MangaEntity>>> getFavorites();
}
