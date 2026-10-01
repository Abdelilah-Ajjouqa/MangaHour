import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chapter_entity.dart';
import '../repositories/chapter_repository.dart';

class GetChaptersParams extends Equatable {
  final int malId;
  final String title;

  const GetChaptersParams({required this.malId, required this.title});

  @override
  List<Object?> get props => [malId, title];
}

@lazySingleton
class GetChaptersUseCase
    implements UseCase<List<ChapterEntity>, GetChaptersParams> {
  final ChapterRepository repository;

  GetChaptersUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChapterEntity>>> call(GetChaptersParams params) {
    return repository.getChapters(malId: params.malId, title: params.title);
  }
}
