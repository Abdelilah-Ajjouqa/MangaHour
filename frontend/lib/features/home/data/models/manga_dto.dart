import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/manga_entity.dart';

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
    // Try to find an Arabic title if it exists in the titles array
    String? arabicTitle;
    if (titles != null) {
      for (final t in titles!) {
        if (t.type != null && t.type!.toLowerCase() == 'arabic') {
          arabicTitle = t.title;
          break;
        }
      }
    }

    return MangaEntity(
      malId: malId,
      title: title,
      arabicTitle: arabicTitle,
      coverUrl: images.jpg.largeImageUrl ?? images.jpg.imageUrl,
      score: score ?? 0.0,
      rank: rank,
      chapters: chapters,
      isPublishing: publishing,
    );
  }
}

@freezed
abstract class MangaImagesDto with _$MangaImagesDto {
  const factory MangaImagesDto({
    required MangaImageFormatDto jpg,
    required MangaImageFormatDto webp,
  }) = _MangaImagesDto;

  factory MangaImagesDto.fromJson(Map<String, dynamic> json) => _$MangaImagesDtoFromJson(json);
}

@freezed
abstract class MangaImageFormatDto with _$MangaImageFormatDto {
  const factory MangaImageFormatDto({
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'small_image_url') String? smallImageUrl,
    @JsonKey(name: 'large_image_url') String? largeImageUrl,
  }) = _MangaImageFormatDto;

  factory MangaImageFormatDto.fromJson(Map<String, dynamic> json) => _$MangaImageFormatDtoFromJson(json);
}

@freezed
abstract class TitleDto with _$TitleDto {
  const factory TitleDto({
    String? type,
    String? title,
  }) = _TitleDto;

  factory TitleDto.fromJson(Map<String, dynamic> json) => _$TitleDtoFromJson(json);
}
