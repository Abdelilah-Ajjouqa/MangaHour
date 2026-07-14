import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_manga_detail_usecase.dart';
import 'manga_detail_event.dart';
import 'manga_detail_state.dart';

@injectable
class MangaDetailBloc extends Bloc<MangaDetailEvent, MangaDetailState> {
  final GetMangaDetailUseCase getMangaDetailUseCase;

  MangaDetailBloc({required this.getMangaDetailUseCase}) : super(MangaDetailInitial()) {
    on<LoadMangaDetail>(_onLoadMangaDetail);
  }

  Future<void> _onLoadMangaDetail(LoadMangaDetail event, Emitter<MangaDetailState> emit) async {
    emit(MangaDetailLoading());

    final result = await getMangaDetailUseCase(event.mangaId);

    result.fold(
      (failure) => emit(MangaDetailError(failure.message)),
      (manga) => emit(MangaDetailLoaded(manga)),
    );
  }
}
