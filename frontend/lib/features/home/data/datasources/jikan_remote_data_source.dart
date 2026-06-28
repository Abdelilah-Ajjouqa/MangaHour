import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../models/manga_dto.dart';

abstract class JikanRemoteDataSource {
  Future<List<MangaDto>> getPopularManga({int page = 1, int limit = 10});
  Future<List<MangaDto>> getTrendingManga({int page = 1, int limit = 10});
}

@LazySingleton(as: JikanRemoteDataSource)
class JikanRemoteDataSourceImpl implements JikanRemoteDataSource {
  final Dio dio;

  JikanRemoteDataSourceImpl(@Named('jikanDio') this.dio);

  @override
  Future<List<MangaDto>> getPopularManga({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get(
        '/top/manga',
        queryParameters: {
          'page': page,
          'limit': limit,
          'type': 'manga',
        },
      );
      
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => MangaDto.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load popular manga');
      }
    } on DioException {
      throw ServerException('Failed to load popular manga');
    }
  }

  @override
  Future<List<MangaDto>> getTrendingManga({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get(
        '/manga',
        queryParameters: {
          'page': page,
          'limit': limit,
          'status': 'publishing',
          'order_by': 'popularity',
          'sort': 'asc',
          'sfw': true,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => MangaDto.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load trending manga');
      }
    } on DioException {
      throw ServerException('Failed to load trending manga');
    }
  }
}
