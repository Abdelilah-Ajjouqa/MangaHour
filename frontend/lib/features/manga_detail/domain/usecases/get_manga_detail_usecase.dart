import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/manga_detail_entity.dart';
import '../repositories/manga_detail_repository.dart';

@lazySingleton
class GetMangaDetailUseCase {
  final MangaDetailRepository repository;

  GetMangaDetailUseCase(this.repository);

  Future<Either<Failure, MangaDetailEntity>> call(int id) {
    return repository.getMangaDetails(id);
  }
}
