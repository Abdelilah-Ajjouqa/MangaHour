import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_chapters_usecase.dart';
import 'chapters_event.dart';
import 'chapters_state.dart';

@injectable
class ChaptersBloc extends Bloc<ChaptersEvent, ChaptersState> {
  final GetChaptersUseCase getChaptersUseCase;

  ChaptersBloc(this.getChaptersUseCase) : super(ChaptersInitial()) {
    on<LoadChapters>(_onLoadChapters);
    on<ToggleSortDirection>(_onToggleSortDirection);
  }

  Future<void> _onLoadChapters(
    LoadChapters event,
    Emitter<ChaptersState> emit,
  ) async {
    emit(ChaptersLoading());

    final result = await getChaptersUseCase(
      GetChaptersParams(malId: event.malId, title: event.title),
    );

    result.fold(
      (failure) => emit(ChaptersError(failure.message)),
      (chapters) => emit(ChaptersLoaded(chapters: chapters, isAscending: true)),
    );
  }

  void _onToggleSortDirection(
    ToggleSortDirection event,
    Emitter<ChaptersState> emit,
  ) {
    if (state is ChaptersLoaded) {
      final current = state as ChaptersLoaded;
      final reversed = current.chapters.reversed.toList();
      emit(
        current.copyWith(chapters: reversed, isAscending: !current.isAscending),
      );
    }
  }
}
