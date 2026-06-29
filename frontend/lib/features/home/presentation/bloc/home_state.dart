import 'package:equatable/equatable.dart';
import '../../domain/entities/manga_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MangaEntity> trendingManga;
  final List<MangaEntity> popularManga;

  const HomeLoaded({
    required this.trendingManga,
    required this.popularManga,
  });

  @override
  List<Object> get props => [trendingManga, popularManga];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
