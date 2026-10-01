import 'package:equatable/equatable.dart';

class ChapterEntity extends Equatable {
  final String id;
  final double chapterNumber;
  final String chapterString;
  final String? title;
  final String language;
  final DateTime? publishAt;
  final int pagesCount;

  const ChapterEntity({
    required this.id,
    required this.chapterNumber,
    required this.chapterString,
    this.title,
    required this.language,
    this.publishAt,
    this.pagesCount = 0,
  });

  bool get isArabic => language == 'ar';

  @override
  List<Object?> get props => [
    id,
    chapterNumber,
    chapterString,
    title,
    language,
    publishAt,
    pagesCount,
  ];
}
