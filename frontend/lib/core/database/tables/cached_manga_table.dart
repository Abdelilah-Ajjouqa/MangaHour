import 'package:drift/drift.dart';

class CachedMangaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get malId => integer()();
  TextColumn get title => text()();
  TextColumn get imageUrl => text()();
  TextColumn get type => text()();
  RealColumn get score => real().nullable()();
  DateTimeColumn get lastUpdated => dateTime()();
  TextColumn get cacheKey => text()(); // e.g. 'trending', 'popular'
}
