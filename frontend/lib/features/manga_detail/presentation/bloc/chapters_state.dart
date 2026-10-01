import 'package:equatable/equatable.dart';

import '../../domain/entities/chapter_entity.dart';

abstract class ChaptersState extends Equatable {
  const ChaptersState();

  @override
  List<Object?> get props => [];
}

class ChaptersInitial extends ChaptersState {}

class ChaptersLoading extends ChaptersState {}

class ChaptersLoaded extends ChaptersState {
  final List<ChapterEntity> chapters;
  final bool isAscending;

  const ChaptersLoaded({required this.chapters, this.isAscending = true});

  ChaptersLoaded copyWith({List<ChapterEntity>? chapters, bool? isAscending}) {
    return ChaptersLoaded(
      chapters: chapters ?? this.chapters,
      isAscending: isAscending ?? this.isAscending,
    );
  }

  @override
  List<Object?> get props => [chapters, isAscending];
}

class ChaptersError extends ChaptersState {
  final String message;

  const ChaptersError(this.message);

  @override
  List<Object?> get props => [message];
}
