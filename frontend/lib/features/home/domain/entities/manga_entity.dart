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

  MangaEntity copyWith({
    int? malId,
    String? title,
    String? arabicTitle,
    String? coverUrl,
    double? score,
    int? rank,
    int? chapters,
    bool? isPublishing,
  }) {
    return MangaEntity(
      malId: malId ?? this.malId,
      title: title ?? this.title,
      arabicTitle: arabicTitle ?? this.arabicTitle,
      coverUrl: coverUrl ?? this.coverUrl,
      score: score ?? this.score,
      rank: rank ?? this.rank,
      chapters: chapters ?? this.chapters,
      isPublishing: isPublishing ?? this.isPublishing,
    );
  }

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
