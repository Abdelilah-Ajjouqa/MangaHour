import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/entities/manga_entity.dart';
import '../../domain/usecases/get_manga_detail_usecase.dart';
import '../../../library/domain/usecases/check_favorite_status_usecase.dart';
import '../../../library/domain/usecases/toggle_favorite_usecase.dart';
import 'manga_detail_event.dart';
import 'manga_detail_state.dart';

@injectable
class MangaDetailBloc extends Bloc<MangaDetailEvent, MangaDetailState> {
  final GetMangaDetailUseCase getMangaDetailUseCase;
  final CheckFavoriteStatusUseCase checkFavoriteStatusUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  
  MangaEntity? _currentMangaEntity; // Need this to pass to toggle use case

  MangaDetailBloc({
    required this.getMangaDetailUseCase,
    required this.checkFavoriteStatusUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(MangaDetailInitial()) {
    on<LoadMangaDetail>(_onLoadMangaDetail);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadMangaDetail(LoadMangaDetail event, Emitter<MangaDetailState> emit) async {
    emit(MangaDetailLoading());

    final result = await getMangaDetailUseCase(event.mangaId);
    final favResult = await checkFavoriteStatusUseCase(event.mangaId);
    
    final isFav = favResult.fold((l) => false, (r) => r);

    result.fold(
      (failure) => emit(MangaDetailError(failure.message)),
      (manga) {
        // Convert MangaDetailEntity to MangaEntity for the favorite toggle
        _currentMangaEntity = MangaEntity(
          malId: manga.malId,
          title: manga.title,
          arabicTitle: manga.arabicTitle,
          coverUrl: manga.coverUrl,
          score: manga.score,
          isPublishing: manga.isPublishing,
        );
        emit(MangaDetailLoaded(manga: manga, isFavorite: isFav));
      },
    );
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<MangaDetailState> emit) async {
    if (state is MangaDetailLoaded && _currentMangaEntity != null) {
      final currentState = state as MangaDetailLoaded;
      final newFavStatus = !currentState.isFavorite;
      
      // Optimistically update UI
      emit(currentState.copyWith(isFavorite: newFavStatus));
      
      final result = await toggleFavoriteUseCase(_currentMangaEntity!);
      
      result.fold(
        (failure) {
          // Revert if failed
          emit(currentState.copyWith(isFavorite: currentState.isFavorite));
        },
        (_) {},
      );
    }
  }
}
