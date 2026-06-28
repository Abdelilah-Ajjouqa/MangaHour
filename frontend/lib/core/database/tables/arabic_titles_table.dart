import 'package:drift/drift.dart';

class ArabicTitlesTable extends Table {
  IntColumn get malId => integer()();
  TextColumn get arabicTitle => text()();

  @override
  Set<Column> get primaryKey => {malId};
}
