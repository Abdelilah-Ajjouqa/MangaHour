import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../app_database.dart';
import '../tables/id_mappings_table.dart';

part 'id_mappings_dao.g.dart';

@DriftAccessor(tables: [IdMappingsTable])
@lazySingleton
class IdMappingsDao extends DatabaseAccessor<AppDatabase> with _$IdMappingsDaoMixin {
  IdMappingsDao(super.db);

  Future<void> saveMapping(int malId, String mangadexId) async {
    await into(idMappingsTable).insertOnConflictUpdate(
      IdMappingsTableData(malId: malId, mangadexId: mangadexId),
    );
  }

  Future<String?> getMangadexId(int malId) async {
    final query = select(idMappingsTable)..where((t) => t.malId.equals(malId));
    final result = await query.getSingleOrNull();
    return result?.mangadexId;
  }

  Future<int?> getMalId(String mangadexId) async {
    final query = select(idMappingsTable)..where((t) => t.mangadexId.equals(mangadexId));
    final result = await query.getSingleOrNull();
    return result?.malId;
  }
}
