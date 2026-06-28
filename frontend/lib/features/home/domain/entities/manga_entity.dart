import 'package:equatable/equatable.dart';

class MangaEntity extends Equatable {
  final int malId;
  final String title;
  final String? arabicTitle;
  final String coverUrl;
  final double score;
  final int? rank;
  final int? chapters;
  final bool isPublishing;

  const MangaEntity({
    required this.malId,
    required this.title,
    this.arabicTitle,
    required this.coverUrl,
    required this.score,
    this.rank,
    this.chapters,
    required this.isPublishing,
  });

  /// Helper to get the display title prioritizing Arabic
  String get displayTitle => arabicTitle ?? title;

  @override
  List<Object?> get props => [
        malId,
        title,
        arabicTitle,
        coverUrl,
        score,
        rank,
        chapters,
        isPublishing,
      ];
}
