import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../entities/manga_entity.dart';
import 'manga_cover_image.dart';

class MangaListPage extends StatelessWidget {
  final String title;
  final List<MangaEntity> mangaList;

  const MangaListPage({
    super.key,
    required this.title,
    required this.mangaList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: mangaList.isEmpty
          ? const Center(child: Text('لا توجد بيانات')) // No data
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: mangaList.length,
              itemBuilder: (context, index) {
                final manga = mangaList[index];
                return GestureDetector(
                  onTap: () => context.push('/manga/${manga.malId}', extra: manga),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: MangaCoverImage(imageUrl: manga.coverUrl),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        manga.arabicTitle ?? manga.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
