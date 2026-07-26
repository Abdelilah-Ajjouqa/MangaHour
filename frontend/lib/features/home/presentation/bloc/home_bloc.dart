import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_popular_manga_usecase.dart';
import '../../domain/usecases/get_trending_manga_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../../core/usecases/usecase.dart';

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

    final results = await Future.wait([
      getTrendingManga(const PaginationParams(limit: 10)),
      getPopularManga(const PaginationParams(limit: 10)),
    ]);

    final trendingResult = results[0];
    final popularResult = results[1];

    trendingResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (trendingManga) {
        popularResult.fold(
          (failure) => emit(HomeError(failure.message)),
          (popularManga) {
            emit(HomeLoaded(
              // The results are typed dynamically due to Future.wait not inferring Either<Failure, List<MangaEntity>> perfectly sometimes without casts, but since both return the same type, we can cast them safely.
              trendingManga: trendingManga as dynamic,
              popularManga: popularManga as dynamic,
            ));
          },
        );
      },
    );
  }
}
