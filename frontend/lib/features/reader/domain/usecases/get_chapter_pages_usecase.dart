import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/reader_repository.dart';

@lazySingleton
class GetChapterPagesUseCase implements UseCase<List<String>, String> {
  final ReaderRepository repository;

  GetChapterPagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(String chapterId) {
    return repository.getChapterPages(chapterId);
  }
}
