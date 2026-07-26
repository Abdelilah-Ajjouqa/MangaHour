import 'package:injectable/injectable.dart';
import '../../../../core/entities/manga_entity.dart';
import '../repositories/home_repository.dart';

import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';

@lazySingleton
class GetOfflineMangaUseCase implements UseCase<List<MangaEntity>, NoParams> {
  final HomeRepository repository;

  GetOfflineMangaUseCase(this.repository);

  @override
  Future<Either<Failure, List<MangaEntity>>> call(NoParams params) async {
    final mangas = await repository.getOfflineManga();
    return Right(mangas);
  }
}
