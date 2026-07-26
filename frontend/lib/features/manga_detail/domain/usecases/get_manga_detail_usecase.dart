import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/manga_detail_entity.dart';
import '../repositories/manga_detail_repository.dart';

import '../../../../core/usecases/usecase.dart';

@lazySingleton
class GetMangaDetailUseCase implements UseCase<MangaDetailEntity, int> {
  final MangaDetailRepository repository;

  GetMangaDetailUseCase(this.repository);

  @override
  Future<Either<Failure, MangaDetailEntity>> call(int params) {
    return repository.getMangaDetails(params);
  }
}
