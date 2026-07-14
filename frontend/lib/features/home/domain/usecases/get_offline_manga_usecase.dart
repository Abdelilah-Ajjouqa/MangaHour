import 'package:injectable/injectable.dart';
import '../entities/manga_entity.dart';
import '../repositories/home_repository.dart';

@lazySingleton
class GetOfflineMangaUseCase {
  final HomeRepository repository;

  GetOfflineMangaUseCase(this.repository);

  Future<List<MangaEntity>> call() {
    return repository.getOfflineManga();
  }
}
