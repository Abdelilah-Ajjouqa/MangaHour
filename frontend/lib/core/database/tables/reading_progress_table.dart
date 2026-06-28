import 'package:drift/drift.dart';

class ReadingProgressTable extends Table {
  IntColumn get malId => integer()();
  TextColumn get mangadexId => text()();
  TextColumn get chapterId => text()();
  TextColumn get chapterTitle => text()();
  IntColumn get lastReadPage => integer()();
  IntColumn get totalPages => integer()();
  DateTimeColumn get lastReadAt => dateTime()();

  @override
  Set<Column> get primaryKey => {mangadexId};
}
