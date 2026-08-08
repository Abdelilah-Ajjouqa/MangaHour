import 'package:equatable/equatable.dart';
import 'manga_reader_state.dart';

abstract class MangaReaderEvent extends Equatable {
  const MangaReaderEvent();

  @override
  List<Object?> get props => [];
}

class LoadChapter extends MangaReaderEvent {
  final String chapterId;

  const LoadChapter(this.chapterId);

  @override
  List<Object?> get props => [chapterId];
}

class PageChanged extends MangaReaderEvent {
  final int pageIndex;

  const PageChanged(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}

class ToggleImmersiveMode extends MangaReaderEvent {}

class ChangeReadingMode extends MangaReaderEvent {
  final ReadingMode mode;

  const ChangeReadingMode(this.mode);

  @override
  List<Object?> get props => [mode];
}
