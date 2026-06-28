import 'package:drift/drift.dart';

class IdMappingsTable extends Table {
  IntColumn get malId => integer()();
  TextColumn get mangadexId => text()();

  @override
  Set<Column> get primaryKey => {malId};
}
