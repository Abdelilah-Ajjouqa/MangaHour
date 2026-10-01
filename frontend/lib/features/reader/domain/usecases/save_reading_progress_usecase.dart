import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/reading_progress_repository.dart';

class SaveReadingProgressParams extends Equatable {
  final int malId;
  final String mangadexId;
  final String chapterId;
  final String chapterTitle;
  final int lastReadPage;
  final int totalPages;

  const SaveReadingProgressParams({
    required this.malId,
    required this.mangadexId,
    required this.chapterId,
    required this.chapterTitle,
    required this.lastReadPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [
    malId,
    mangadexId,
    chapterId,
    chapterTitle,
    lastReadPage,
    totalPages,
  ];
}

@lazySingleton
class SaveReadingProgressUseCase
    implements UseCase<void, SaveReadingProgressParams> {
  final ReadingProgressRepository repository;

  SaveReadingProgressUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveReadingProgressParams params) {
    return repository.saveProgress(
      malId: params.malId,
      mangadexId: params.mangadexId,
      chapterId: params.chapterId,
      chapterTitle: params.chapterTitle,
      lastReadPage: params.lastReadPage,
      totalPages: params.totalPages,
    );
  }
}
