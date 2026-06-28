import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_popular_manga_usecase.dart';
import '../../domain/usecases/get_trending_manga_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTrendingMangaUseCase getTrendingManga;
  final GetPopularMangaUseCase getPopularManga;

  HomeBloc({
    required this.getTrendingManga,
    required this.getPopularManga,
  }) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    final trendingResult = await getTrendingManga(limit: 10);
    final popularResult = await getPopularManga(limit: 10);

    trendingResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (trendingManga) {
        popularResult.fold(
          (failure) => emit(HomeError(failure.message)),
          (popularManga) {
            emit(HomeLoaded(
              trendingManga: trendingManga,
              popularManga: popularManga,
            ));
          },
        );
      },
    );
  }
}
