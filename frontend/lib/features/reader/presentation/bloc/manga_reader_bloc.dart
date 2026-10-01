import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/usecases/get_chapter_pages_usecase.dart';
import '../../domain/usecases/save_reading_progress_usecase.dart';
import 'manga_reader_event.dart';
import 'manga_reader_state.dart';

const String _readingModeKey = 'PREF_READING_MODE';

@injectable
class MangaReaderBloc extends Bloc<MangaReaderEvent, MangaReaderState> {
  final SharedPreferences _prefs;
  final GetChapterPagesUseCase _getChapterPagesUseCase;
  final SaveReadingProgressUseCase _saveReadingProgressUseCase;

  int? _malId;
  String? _mangadexId;
  String? _currentChapterId;
  String? _chapterTitle;
  int _totalPages = 0;

  MangaReaderBloc(
    this._prefs,
    this._getChapterPagesUseCase,
    this._saveReadingProgressUseCase,
  ) : super(MangaReaderLoading()) {
    on<LoadChapter>(_onLoadChapter);
    on<PageChanged>(_onPageChanged);
    on<ToggleImmersiveMode>(_onToggleImmersiveMode);
    on<ChangeReadingMode>(_onChangeReadingMode);
  }

  Future<void> _onLoadChapter(
    LoadChapter event,
    Emitter<MangaReaderState> emit,
  ) async {
    emit(MangaReaderLoading());

    _malId = event.malId;
    _mangadexId = event.mangadexId;
    _currentChapterId = event.chapterId;
    _chapterTitle = event.chapterTitle;

    final result = await _getChapterPagesUseCase(event.chapterId);

    result.fold((failure) => emit(MangaReaderError(failure.message)), (pages) {
      if (pages.isEmpty) {
        emit(const MangaReaderError('لا توجد صفحات متوفرة لهذا الفصل'));
        return;
      }

      _totalPages = pages.length;

      // Load saved reading mode preference
      final savedModeIndex = _prefs.getInt(_readingModeKey);
      final readingMode =
          savedModeIndex != null &&
              savedModeIndex >= 0 &&
              savedModeIndex < ReadingMode.values.length
          ? ReadingMode.values[savedModeIndex]
          : ReadingMode.horizontalRtl;

      emit(
        MangaReaderLoaded(
          pages: pages,
          currentPage: 0,
          isImmersiveMode: true,
          readingMode: readingMode,
        ),
      );

      // Save initial reading progress if metadata exists
      _persistProgress(0);
    });
  }

  void _onPageChanged(PageChanged event, Emitter<MangaReaderState> emit) {
    if (state is MangaReaderLoaded) {
      final currentState = state as MangaReaderLoaded;
      emit(currentState.copyWith(currentPage: event.pageIndex));
      _persistProgress(event.pageIndex);
    }
  }

  void _persistProgress(int pageIndex) {
    if (_malId != null && _mangadexId != null && _currentChapterId != null) {
      _saveReadingProgressUseCase(
        SaveReadingProgressParams(
          malId: _malId!,
          mangadexId: _mangadexId!,
          chapterId: _currentChapterId!,
          chapterTitle: _chapterTitle ?? '',
          lastReadPage: pageIndex + 1,
          totalPages: _totalPages,
        ),
      );
    }
  }

  void _onToggleImmersiveMode(
    ToggleImmersiveMode event,
    Emitter<MangaReaderState> emit,
  ) {
    if (state is MangaReaderLoaded) {
      final currentState = state as MangaReaderLoaded;
      emit(
        currentState.copyWith(isImmersiveMode: !currentState.isImmersiveMode),
      );
    }
  }

  Future<void> _onChangeReadingMode(
    ChangeReadingMode event,
    Emitter<MangaReaderState> emit,
  ) async {
    if (state is MangaReaderLoaded) {
      final currentState = state as MangaReaderLoaded;

      await _prefs.setInt(_readingModeKey, event.mode.index);
      emit(currentState.copyWith(readingMode: event.mode));
    }
  }
}
