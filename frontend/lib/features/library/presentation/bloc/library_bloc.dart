import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/usecases/get_offline_manga_usecase.dart';
import 'library_event.dart';
import 'library_state.dart';

@injectable
class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final GetOfflineMangaUseCase getOfflineManga;

  LibraryBloc({required this.getOfflineManga}) : super(LibraryInitial()) {
    on<LoadOfflineManga>(_onLoadOfflineManga);
  }

  Future<void> _onLoadOfflineManga(LoadOfflineManga event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());

    final result = await getOfflineManga(NoParams());
    
    result.fold(
      (failure) => emit(LibraryError(failure.message)),
      (mangaList) => emit(LibraryLoaded(mangaList)),
    );
  }
}
