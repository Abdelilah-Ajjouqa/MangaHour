import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_dtos.freezed.dart';
part 'shared_dtos.g.dart';

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
