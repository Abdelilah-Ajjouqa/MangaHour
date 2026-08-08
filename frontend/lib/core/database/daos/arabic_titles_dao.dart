import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../app_database.dart';
import '../tables/arabic_titles_table.dart';

part 'arabic_titles_dao.g.dart';

@DriftAccessor(tables: [ArabicTitlesTable])
@lazySingleton
class ArabicTitlesDao extends DatabaseAccessor<AppDatabase> with _$ArabicTitlesDaoMixin {
  ArabicTitlesDao(super.db);

  Future<void> cacheArabicTitle(int id, String title) async {
    await into(arabicTitlesTable).insertOnConflictUpdate(
      ArabicTitlesTableData(malId: id, arabicTitle: title),
    );
  }

  Future<Map<int, String>> getArabicTitlesForIds(List<int> malIds) async {
    if (malIds.isEmpty) return {};
    final query = select(arabicTitlesTable)..where((t) => t.malId.isIn(malIds));
    final results = await query.get();
    return {for (var r in results) r.malId: r.arabicTitle};
  }
}
