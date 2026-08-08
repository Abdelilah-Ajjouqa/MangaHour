import 'package:injectable/injectable.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../home/data/models/manga_dto.dart';

abstract class ExploreRemoteDataSource {
  Future<List<MangaDto>> searchManga(String query);
}

@LazySingleton(as: ExploreRemoteDataSource)
class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  @override
  Future<List<MangaDto>> searchManga(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Combine mock data to create a larger pool
    final allMockData = [...MockData.popularMangaList, ...MockData.trendingMangaList];
    
    // Remove duplicates based on ID (since mock data might overlap)
    final uniqueMap = <int, Map<String, dynamic>>{};
    for (var item in allMockData) {
      uniqueMap[item['mal_id'] as int] = item;
    }
    
    final allManga = uniqueMap.values.map((json) => MangaDto.fromJson(json)).toList();

    if (query.isEmpty) {
      return allManga;
    }

    // Filter by query (english or arabic)
    final lowercaseQuery = query.toLowerCase();
    return allManga.where((manga) {
      final englishMatch = manga.title.toLowerCase().contains(lowercaseQuery);
      final arabicMatch = manga.titles?.any((t) => t.title?.contains(query) ?? false) ?? false;
      return englishMatch || arabicMatch;
    }).toList();
  }
}
