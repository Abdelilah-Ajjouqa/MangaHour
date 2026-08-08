import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/entities/manga_entity.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/manga_dao.dart';
import '../../domain/repositories/favorites_repository.dart';

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  final MangaDao mangaDao;

  FavoritesRepositoryImpl(this.mangaDao);

  @override
  Future<Either<Failure, void>> addFavorite(MangaEntity manga) async {
    try {
      final companion = FavoritesTableCompanion(
        malId: Value(manga.malId),
        title: Value(manga.title),
        imageUrl: Value(manga.coverUrl),
        addedAt: Value(DateTime.now()),
      );
      await mangaDao.addFavorite(companion);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add favorite'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int malId) async {
    try {
      await mangaDao.removeFavorite(malId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to remove favorite'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int malId) async {
    try {
      final isFav = await mangaDao.isFavorite(malId);
      return Right(isFav);
    } catch (e) {
      return Left(CacheFailure('Failed to check favorite status'));
    }
  }

  @override
  Future<Either<Failure, List<MangaEntity>>> getFavorites() async {
    try {
      final favs = await mangaDao.getFavorites();
      final entities = favs.map((f) => MangaEntity(
        malId: f.malId,
        title: f.title,
        arabicTitle: f.title, // For now we store one title
        coverUrl: f.imageUrl,
        score: 0.0,
        isPublishing: false,
      )).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure('Failed to get favorites'));
    }
  }
}
