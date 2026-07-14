import 'package:equatable/equatable.dart';

abstract class MangaDetailEvent extends Equatable {
  const MangaDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadMangaDetail extends MangaDetailEvent {
  final int mangaId;

  const LoadMangaDetail(this.mangaId);

  @override
  List<Object> get props => [mangaId];
}
