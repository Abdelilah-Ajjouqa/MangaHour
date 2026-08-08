import 'package:equatable/equatable.dart';
import '../../domain/entities/manga_detail_entity.dart';

abstract class MangaDetailState extends Equatable {
  const MangaDetailState();
  
  @override
  List<Object> get props => [];
}

class MangaDetailInitial extends MangaDetailState {}

class MangaDetailLoading extends MangaDetailState {}

class MangaDetailLoaded extends MangaDetailState {
  final MangaDetailEntity manga;
  final bool isFavorite;

  const MangaDetailLoaded({required this.manga, this.isFavorite = false});

  MangaDetailLoaded copyWith({
    MangaDetailEntity? manga,
    bool? isFavorite,
  }) {
    return MangaDetailLoaded(
      manga: manga ?? this.manga,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object> get props => [manga, isFavorite];
}

class MangaDetailError extends MangaDetailState {
  final String message;

  const MangaDetailError(this.message);

  @override
  List<Object> get props => [message];
}
