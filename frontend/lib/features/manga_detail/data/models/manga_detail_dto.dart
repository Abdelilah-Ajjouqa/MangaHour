import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/models/shared_dtos.dart';
import '../../../../core/utils/arabic_title_extractor.dart';
import '../../domain/entities/manga_detail_entity.dart';

part 'manga_detail_dto.freezed.dart';
part 'manga_detail_dto.g.dart';

@freezed
abstract class MangaDetailDto with _$MangaDetailDto {
  const MangaDetailDto._();

  const factory MangaDetailDto({
    @JsonKey(name: 'mal_id') required int malId,
    required String title,
    @JsonKey(name: 'title_english') String? titleEnglish,
    required MangaImagesDto images,
    double? score,
    int? chapters,
    required bool publishing,
    List<TitleDto>? titles,
    String? synopsis,
    String? status,
    List<AuthorDto>? authors,
  }) = _MangaDetailDto;

  factory MangaDetailDto.fromJson(Map<String, dynamic> json) => _$MangaDetailDtoFromJson(json);

  MangaDetailEntity toEntity() {

    String authorName = 'غير معروف';
    if (authors != null && authors!.isNotEmpty) {
      authorName = authors!.first.name ?? 'غير معروف';
    }

    return MangaDetailEntity(
      malId: malId,
      title: title,
      arabicTitle: ArabicTitleExtractor.extract(titles),
      coverUrl: images.jpg.largeImageUrl ?? images.jpg.imageUrl,
      score: score ?? 0.0,
      isPublishing: publishing,
      synopsis: synopsis ?? 'لا توجد قصة متاحة.',
      author: authorName,
      status: status ?? (publishing ? 'مستمر' : 'مكتمل'),
      totalChapters: chapters ?? 0,
    );
  }
}

@freezed
abstract class AuthorDto with _$AuthorDto {
  const factory AuthorDto({
    @JsonKey(name: 'mal_id') int? malId,
    String? type,
    String? name,
    String? url,
  }) = _AuthorDto;

  factory AuthorDto.fromJson(Map<String, dynamic> json) => _$AuthorDtoFromJson(json);
}
