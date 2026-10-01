import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../manga_detail/data/models/mangadex_models.dart';

abstract class ReaderRemoteDataSource {
  Future<MangaDexAtHomeDto> getChapterAtHome(String chapterId);
}

@LazySingleton(as: ReaderRemoteDataSource)
class ReaderRemoteDataSourceImpl implements ReaderRemoteDataSource {
  final Dio dio;

  ReaderRemoteDataSourceImpl(@Named('mangadexDio') this.dio);

  @override
  Future<MangaDexAtHomeDto> getChapterAtHome(String chapterId) async {
    final response = await dio.get(ApiConstants.mangadexAtHome(chapterId));
    return MangaDexAtHomeDto.fromJson(response.data as Map<String, dynamic>);
  }
}
