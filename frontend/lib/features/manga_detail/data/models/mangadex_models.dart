import '../../domain/entities/chapter_entity.dart';

class MangaDexMangaDto {
  final String id;
  final String? malId;
  final String title;

  const MangaDexMangaDto({required this.id, this.malId, required this.title});

  factory MangaDexMangaDto.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>? ?? {};
    final links = attributes['links'] as Map<String, dynamic>?;
    final mal = links?['mal']?.toString();

    final titlesMap = attributes['title'] as Map<String, dynamic>? ?? {};
    final titleStr = titlesMap.values.isNotEmpty
        ? titlesMap.values.first.toString()
        : 'Unknown';

    return MangaDexMangaDto(
      id: json['id'] as String,
      malId: mal,
      title: titleStr,
    );
  }
}

class MangaDexChapterDto {
  final String id;
  final String? chapter;
  final String? title;
  final String translatedLanguage;
  final DateTime? publishAt;
  final int pages;

  const MangaDexChapterDto({
    required this.id,
    this.chapter,
    this.title,
    required this.translatedLanguage,
    this.publishAt,
    required this.pages,
  });

  factory MangaDexChapterDto.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>? ?? {};
    DateTime? parsedDate;
    if (attributes['publishAt'] != null) {
      parsedDate = DateTime.tryParse(attributes['publishAt'].toString());
    }

    return MangaDexChapterDto(
      id: json['id'] as String,
      chapter: attributes['chapter']?.toString(),
      title: attributes['title']?.toString(),
      translatedLanguage: attributes['translatedLanguage']?.toString() ?? 'en',
      publishAt: parsedDate,
      pages: (attributes['pages'] as num?)?.toInt() ?? 0,
    );
  }

  ChapterEntity toEntity() {
    final cleanChapterStr = chapter ?? '0';
    final parsedNumber = double.tryParse(cleanChapterStr) ?? 0.0;

    return ChapterEntity(
      id: id,
      chapterNumber: parsedNumber,
      chapterString: cleanChapterStr,
      title: (title != null && title!.trim().isNotEmpty) ? title!.trim() : null,
      language: translatedLanguage,
      publishAt: publishAt,
      pagesCount: pages,
    );
  }
}

class MangaDexAtHomeDto {
  final String baseUrl;
  final String hash;
  final List<String> data;
  final List<String> dataSaver;

  const MangaDexAtHomeDto({
    required this.baseUrl,
    required this.hash,
    required this.data,
    required this.dataSaver,
  });

  factory MangaDexAtHomeDto.fromJson(Map<String, dynamic> json) {
    final chapter = json['chapter'] as Map<String, dynamic>? ?? {};
    final dataFiles =
        (chapter['data'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final dataSaverFiles =
        (chapter['dataSaver'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return MangaDexAtHomeDto(
      baseUrl: json['baseUrl'] as String? ?? 'https://uploads.mangadex.org',
      hash: chapter['hash'] as String? ?? '',
      data: dataFiles,
      dataSaver: dataSaverFiles,
    );
  }

  List<String> getPageUrls({bool useDataSaver = false}) {
    final mode = useDataSaver ? 'data-saver' : 'data';
    final files = useDataSaver && dataSaver.isNotEmpty ? dataSaver : data;

    return files.map((fileName) => '$baseUrl/$mode/$hash/$fileName').toList();
  }
}
