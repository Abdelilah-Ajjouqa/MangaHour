import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/mock/mock_data.dart';
import '../models/manga_detail_dto.dart';

abstract class MangaDetailRemoteDataSource {
  Future<MangaDetailDto> getMangaDetails(int id);
}

@LazySingleton(as: MangaDetailRemoteDataSource)
class MangaDetailRemoteDataSourceImpl implements MangaDetailRemoteDataSource {
  final Dio dio;

  MangaDetailRemoteDataSourceImpl(@Named('jikanDio') this.dio);

  @override
  Future<MangaDetailDto> getMangaDetails(int id) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));
    return MangaDetailDto.fromJson(MockData.mangaDetail);
  }
}
