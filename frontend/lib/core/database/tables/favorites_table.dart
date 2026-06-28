import 'package:drift/drift.dart';

class FavoritesTable extends Table {
  IntColumn get malId => integer()();
  TextColumn get title => text()();
  TextColumn get imageUrl => text()();
  DateTimeColumn get addedAt => dateTime()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {malId};
}
