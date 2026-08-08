import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/mock/mock_data.dart';
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
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));
    return MockData.popularMangaList.map((json) => MangaDto.fromJson(json)).toList();
  }

  @override
  Future<List<MangaDto>> getTrendingManga({int page = 1, int limit = 10}) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));
    return MockData.trendingMangaList.map((json) => MangaDto.fromJson(json)).toList();
  }
}
