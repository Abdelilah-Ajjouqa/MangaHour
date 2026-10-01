import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/manga_detail/data/models/mangadex_models.dart';
import 'package:frontend/features/manga_detail/domain/entities/chapter_entity.dart';

void main() {
  group('MangaDex Models & Prioritization Tests', () {
    test('MangaDexMangaDto correctly extracts malId and title', () {
      final json = {
        'id': 'md-12345',
        'attributes': {
          'title': {'en': 'One Piece'},
          'links': {'mal': '13'},
        },
      };

      final dto = MangaDexMangaDto.fromJson(json);
      expect(dto.id, 'md-12345');
      expect(dto.malId, '13');
      expect(dto.title, 'One Piece');
    });

    test('MangaDexChapterDto converts to ChapterEntity correctly', () {
      final json = {
        'id': 'chap-uuid-1',
        'attributes': {
          'chapter': '10.5',
          'title': 'The Adventure Begins',
          'translatedLanguage': 'ar',
          'pages': 24,
          'publishAt': '2023-10-01T12:00:00Z',
        },
      };

      final dto = MangaDexChapterDto.fromJson(json);
      final entity = dto.toEntity();

      expect(entity.id, 'chap-uuid-1');
      expect(entity.chapterNumber, 10.5);
      expect(entity.chapterString, '10.5');
      expect(entity.title, 'The Adventure Begins');
      expect(entity.language, 'ar');
      expect(entity.isArabic, true);
      expect(entity.pagesCount, 24);
    });

    test(
      'Arabic chapters correctly override English chapters with same number',
      () {
        final englishChapter = MangaDexChapterDto(
          id: 'en-1',
          chapter: '1',
          title: 'Romance Dawn EN',
          translatedLanguage: 'en',
          publishAt: DateTime.now(),
          pages: 50,
        ).toEntity();

        final arabicChapter = MangaDexChapterDto(
          id: 'ar-1',
          chapter: '1',
          title: 'فجر المغامرة',
          translatedLanguage: 'ar',
          publishAt: DateTime.now(),
          pages: 50,
        ).toEntity();

        final Map<String, ChapterEntity> chapterMap = {};

        for (final ch in [englishChapter, arabicChapter]) {
          final key = ch.chapterString;
          if (!chapterMap.containsKey(key)) {
            chapterMap[key] = ch;
          } else {
            final existing = chapterMap[key]!;
            if (!existing.isArabic && ch.isArabic) {
              chapterMap[key] = ch;
            }
          }
        }

        expect(chapterMap['1']!.id, 'ar-1');
        expect(chapterMap['1']!.isArabic, true);
        expect(chapterMap['1']!.title, 'فجر المغامرة');
      },
    );

    test('MangaDexAtHomeDto constructs correct image URLs', () {
      final json = {
        'baseUrl': 'https://uploads.mangadex.org',
        'chapter': {
          'hash': 'hash123',
          'data': ['1.png', '2.png'],
          'dataSaver': ['1.jpg', '2.jpg'],
        },
      };

      final dto = MangaDexAtHomeDto.fromJson(json);

      final originalUrls = dto.getPageUrls(useDataSaver: false);
      expect(originalUrls, [
        'https://uploads.mangadex.org/data/hash123/1.png',
        'https://uploads.mangadex.org/data/hash123/2.png',
      ]);

      final saverUrls = dto.getPageUrls(useDataSaver: true);
      expect(saverUrls, [
        'https://uploads.mangadex.org/data-saver/hash123/1.jpg',
        'https://uploads.mangadex.org/data-saver/hash123/2.jpg',
      ]);
    });
  });
}
