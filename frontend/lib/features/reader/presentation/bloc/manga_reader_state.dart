import 'package:equatable/equatable.dart';

enum ReadingMode {
  horizontalRtl,
  verticalWebtoon,
}

abstract class MangaReaderState extends Equatable {
  const MangaReaderState();
  
  @override
  List<Object?> get props => [];
}

class MangaReaderLoading extends MangaReaderState {}

class MangaReaderLoaded extends MangaReaderState {
  final List<String> pages;
  final int currentPage;
  final bool isImmersiveMode;
  final ReadingMode readingMode;

  const MangaReaderLoaded({
    required this.pages,
    this.currentPage = 0,
    this.isImmersiveMode = true,
    this.readingMode = ReadingMode.horizontalRtl,
  });

  MangaReaderLoaded copyWith({
    List<String>? pages,
    int? currentPage,
    bool? isImmersiveMode,
    ReadingMode? readingMode,
  }) {
    return MangaReaderLoaded(
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
      isImmersiveMode: isImmersiveMode ?? this.isImmersiveMode,
      readingMode: readingMode ?? this.readingMode,
    );
  }

  @override
  List<Object?> get props => [pages, currentPage, isImmersiveMode, readingMode];
}

class MangaReaderError extends MangaReaderState {
  final String message;

  const MangaReaderError(this.message);

  @override
  List<Object?> get props => [message];
}
