import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/entities/manga_entity.dart';
import '../../../../core/models/shared_dtos.dart';
import '../../../../core/utils/arabic_title_extractor.dart';

part 'manga_dto.freezed.dart';
part 'manga_dto.g.dart';

@freezed
abstract class MangaDto with _$MangaDto {
  const MangaDto._();

  const factory MangaDto({
    @JsonKey(name: 'mal_id') required int malId,
    required String title,
    @JsonKey(name: 'title_english') String? titleEnglish,
    @JsonKey(name: 'title_japanese') String? titleJapanese,
    required MangaImagesDto images,
    double? score,
    int? rank,
    int? chapters,
    required bool publishing,
    List<TitleDto>? titles,
  }) = _MangaDto;

  factory MangaDto.fromJson(Map<String, dynamic> json) => _$MangaDtoFromJson(json);

  MangaEntity toEntity() {
    return MangaEntity(
      malId: malId,
      title: title,
      arabicTitle: ArabicTitleExtractor.extract(titles),
      coverUrl: images.jpg.largeImageUrl ?? images.jpg.imageUrl,
      score: score ?? 0.0,
      rank: rank,
      chapters: chapters,
      isPublishing: publishing,
    );
  }
}

