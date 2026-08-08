import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manga_reader_event.dart';
import 'manga_reader_state.dart';

const String _readingModeKey = 'PREF_READING_MODE';

@injectable
class MangaReaderBloc extends Bloc<MangaReaderEvent, MangaReaderState> {
  final SharedPreferences _prefs;

  MangaReaderBloc(this._prefs) : super(MangaReaderLoading()) {
    on<LoadChapter>(_onLoadChapter);
    on<PageChanged>(_onPageChanged);
    on<ToggleImmersiveMode>(_onToggleImmersiveMode);
    on<ChangeReadingMode>(_onChangeReadingMode);
  }

  Future<void> _onLoadChapter(LoadChapter event, Emitter<MangaReaderState> emit) async {
    emit(MangaReaderLoading());

    try {
      // Mock loading pages delay
      await Future.delayed(const Duration(milliseconds: 500));

      final mockPages = List.generate(
          20,
          (index) =>
              'https://picsum.photos/seed/${event.chapterId}_$index/800/1200');

      // Load preference
      final savedModeIndex = _prefs.getInt(_readingModeKey);
      final readingMode = savedModeIndex != null
          ? ReadingMode.values[savedModeIndex]
          : ReadingMode.horizontalRtl;

      emit(MangaReaderLoaded(
        pages: mockPages,
        currentPage: 0,
        isImmersiveMode: true,
        readingMode: readingMode,
      ));
    } catch (e) {
      emit(MangaReaderError('Failed to load chapter: $e'));
    }
  }

  void _onPageChanged(PageChanged event, Emitter<MangaReaderState> emit) {
    if (state is MangaReaderLoaded) {
      final currentState = state as MangaReaderLoaded;
      emit(currentState.copyWith(currentPage: event.pageIndex));
    }
  }

  void _onToggleImmersiveMode(ToggleImmersiveMode event, Emitter<MangaReaderState> emit) {
    if (state is MangaReaderLoaded) {
      final currentState = state as MangaReaderLoaded;
      emit(currentState.copyWith(isImmersiveMode: !currentState.isImmersiveMode));
    }
  }

  Future<void> _onChangeReadingMode(ChangeReadingMode event, Emitter<MangaReaderState> emit) async {
    if (state is MangaReaderLoaded) {
      final currentState = state as MangaReaderLoaded;
      
      // Save preference
      await _prefs.setInt(_readingModeKey, event.mode.index);

      emit(currentState.copyWith(readingMode: event.mode));
    }
  }
}
