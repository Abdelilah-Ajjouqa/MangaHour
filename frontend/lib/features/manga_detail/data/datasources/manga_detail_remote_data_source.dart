import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/error/exceptions.dart';
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
    try {
      final response = await dio.get('/manga/$id/full');
      if (response.statusCode == 200) {
        return MangaDetailDto.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to load manga details');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to connect to server');
    }
  }
}
