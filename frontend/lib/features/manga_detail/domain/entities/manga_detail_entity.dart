import '../../../../core/entities/manga_entity.dart';

class MangaDetailEntity extends MangaEntity {
  final String synopsis;
  final String author;
  final String status;
  final int totalChapters;

  const MangaDetailEntity({
    required super.malId,
    required super.title,
    super.arabicTitle,
    required super.coverUrl,
    required super.score,
    required super.isPublishing,
    required this.synopsis,
    required this.author,
    required this.status,
    required this.totalChapters,
  });

  @override
  List<Object?> get props => [
        malId,
        title,
        arabicTitle,
        coverUrl,
        score,
        isPublishing,
        synopsis,
        author,
        status,
        totalChapters,
      ];
}
