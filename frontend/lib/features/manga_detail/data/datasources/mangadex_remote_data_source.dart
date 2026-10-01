import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/mangadex_models.dart';

abstract class MangaDexRemoteDataSource {
  Future<String?> searchMangaDexId({required String title, required int malId});
  Future<List<MangaDexChapterDto>> getChapterFeed({
    required String mangadexId,
    int limit = 100,
    int offset = 0,
  });
}

@LazySingleton(as: MangaDexRemoteDataSource)
class MangaDexRemoteDataSourceImpl implements MangaDexRemoteDataSource {
  final Dio dio;

  MangaDexRemoteDataSourceImpl(@Named('mangadexDio') this.dio);

  @override
  Future<String?> searchMangaDexId({
    required String title,
    required int malId,
  }) async {
    final response = await dio.get(
      ApiConstants.mangadexManga,
      queryParameters: {
        'title': title,
        'limit': 10,
        'order[relevance]': 'desc',
        'contentRating[]': ['safe', 'suggestive', 'erotica'],
      },
    );

    final dataList = response.data['data'] as List<dynamic>? ?? [];
    if (dataList.isEmpty) return null;

    final mangas = dataList
        .map((json) => MangaDexMangaDto.fromJson(json as Map<String, dynamic>))
        .toList();

    // 1. Exact MAL ID match
    final malStr = malId.toString();
    for (final manga in mangas) {
      if (manga.malId == malStr) {
        return manga.id;
      }
    }

    // 2. Fallback to top relevant result
    return mangas.first.id;
  }

  @override
  Future<List<MangaDexChapterDto>> getChapterFeed({
    required String mangadexId,
    int limit = 100,
    int offset = 0,
  }) async {
    final response = await dio.get(
      ApiConstants.mangadexChapterFeed(mangadexId),
      queryParameters: {
        'translatedLanguage[]': ['ar', 'en'],
        'order[chapter]': 'asc',
        'limit': limit,
        'offset': offset,
        'contentRating[]': ['safe', 'suggestive', 'erotica'],
      },
    );

    final dataList = response.data['data'] as List<dynamic>? ?? [];
    return dataList
        .map(
          (json) => MangaDexChapterDto.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
