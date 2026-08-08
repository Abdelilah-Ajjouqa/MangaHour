import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/search_manga_usecase.dart';
import 'explore_event.dart';
import 'explore_state.dart';

@injectable
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final SearchMangaUseCase searchMangaUseCase;
  String currentQuery = '';

  ExploreBloc(this.searchMangaUseCase) : super(const ExploreState.initial()) {
    on<ExploreEvent>((event, emit) async {
      await event.map(
        searchQueryChanged: (e) async => _onSearchQueryChanged(e.query, emit),
        genreFilterChanged: (e) async => _onGenreFilterChanged(e.genre, emit),
      );
    });
  }

  Future<void> _onSearchQueryChanged(String query, Emitter<ExploreState> emit) async {
    currentQuery = query;
    emit(const ExploreState.loading());
    final result = await searchMangaUseCase(query);
    result.fold(
      (failure) => emit(ExploreState.error(failure.message)),
      (mangaList) => emit(ExploreState.loaded(mangaList)),
    );
  }

  Future<void> _onGenreFilterChanged(String genre, Emitter<ExploreState> emit) async {
    final query = genre == 'الكل' ? '' : genre;
    currentQuery = query;
    emit(const ExploreState.loading());
    final result = await searchMangaUseCase(query);
    result.fold(
      (failure) => emit(ExploreState.error(failure.message)),
      (mangaList) => emit(ExploreState.loaded(mangaList)),
    );
  }
}
