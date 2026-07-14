import 'package:flutter/material.dart';
import '../../domain/entities/manga_entity.dart';
import 'popular_manga_card.dart';

class OfflineDashboardWidget extends StatelessWidget {
  final List<MangaEntity> installedManga;

  const OfflineDashboardWidget({
    super.key,
    required this.installedManga,
  });

  @override
  Widget build(BuildContext context) {
    if (installedManga.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_off_rounded,
              size: 80,
              color: Colors.white24,
            ),
            const SizedBox(height: 24),
            Text(
              'لا يوجد محتوى محمل محلياً',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'يرجى الاتصال بالإنترنت لتحميل المانجا',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: Text(
                'المانجا المحملة', // Downloaded Manga
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PopularMangaCard(
                  manga: installedManga[index],
                  index: index,
                );
              },
              childCount: installedManga.length,
            ),
          ),
        ],
      ),
    );
  }
}
