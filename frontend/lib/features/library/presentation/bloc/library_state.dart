import '../../../../core/entities/manga_entity.dart';

abstract class LibraryState {}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<MangaEntity> offlineManga;

  LibraryLoaded(this.offlineManga);
}

class LibraryError extends LibraryState {
  final String message;

  LibraryError(this.message);
}
