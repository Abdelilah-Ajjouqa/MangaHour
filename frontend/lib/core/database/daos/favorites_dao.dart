import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../app_database.dart';
import '../tables/favorites_table.dart';

part 'favorites_dao.g.dart';

@DriftAccessor(tables: [FavoritesTable])
@lazySingleton
class FavoritesDao extends DatabaseAccessor<AppDatabase> with _$FavoritesDaoMixin {
  FavoritesDao(super.db);

  Future<void> addFavorite(FavoritesTableCompanion favorite) async {
    await into(favoritesTable).insertOnConflictUpdate(favorite);
  }

  Future<void> removeFavorite(int malId) async {
    await (delete(favoritesTable)..where((t) => t.malId.equals(malId))).go();
  }

  Future<bool> isFavorite(int malId) async {
    final query = select(favoritesTable)..where((t) => t.malId.equals(malId));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  Future<List<FavoritesTableData>> getFavorites() {
    final query = select(favoritesTable)
      ..orderBy([(t) => OrderingTerm(expression: t.addedAt, mode: OrderingMode.desc)]);
    return query.get();
  }
}
