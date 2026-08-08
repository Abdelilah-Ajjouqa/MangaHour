import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/usecases/get_offline_manga_usecase.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import 'library_event.dart';
import 'library_state.dart';

@injectable
class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final GetOfflineMangaUseCase getOfflineManga;
  final GetFavoritesUseCase getFavorites;

  LibraryBloc({
    required this.getOfflineManga,
    required this.getFavorites,
  }) : super(LibraryInitial()) {
    on<LoadLibraryData>(_onLoadLibraryData);
  }

  Future<void> _onLoadLibraryData(LoadLibraryData event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());

    final offlineResult = await getOfflineManga(NoParams());
    final favResult = await getFavorites(NoParams());
    
    if (offlineResult.isLeft() && favResult.isLeft()) {
      emit(LibraryError('حدث خطأ أثناء تحميل المكتبة'));
      return;
    }
    
    final offline = offlineResult.getOrElse(() => []);
    final favs = favResult.getOrElse(() => []);
    
    emit(LibraryLoaded(favorites: favs, offlineManga: offline));
  }
}
