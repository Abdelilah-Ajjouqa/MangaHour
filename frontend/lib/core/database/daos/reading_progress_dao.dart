import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../app_database.dart';
import '../tables/reading_progress_table.dart';

part 'reading_progress_dao.g.dart';

@DriftAccessor(tables: [ReadingProgressTable])
@lazySingleton
class ReadingProgressDao extends DatabaseAccessor<AppDatabase> with _$ReadingProgressDaoMixin {
  ReadingProgressDao(super.db);

  Future<void> saveProgress(ReadingProgressTableCompanion progress) async {
    await into(readingProgressTable).insertOnConflictUpdate(progress);
  }

  Future<ReadingProgressTableData?> getProgress(String mangadexId) async {
    final query = select(readingProgressTable)..where((t) => t.mangadexId.equals(mangadexId));
    return query.getSingleOrNull();
  }

  Future<List<ReadingProgressTableData>> getAllHistory() async {
    final query = select(readingProgressTable)
      ..orderBy([(t) => OrderingTerm(expression: t.lastReadAt, mode: OrderingMode.desc)]);
    return query.get();
  }

  Future<void> clearHistoryForManga(String mangadexId) async {
    await (delete(readingProgressTable)..where((t) => t.mangadexId.equals(mangadexId))).go();
  }
}
