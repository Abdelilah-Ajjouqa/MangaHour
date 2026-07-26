import 'package:flutter/material.dart';
import '../../../../core/widgets/manga_cover_image.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/entities/manga_entity.dart';

class PopularMangaCard extends StatelessWidget {
  final MangaEntity manga;
  final int index;

  const PopularMangaCard({super.key, required this.manga, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/manga/${manga.malId}', extra: manga);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: MangaCoverImage(
                    imageUrl: manga.coverUrl,
                  ),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.overlay,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            manga.displayTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.star, size: 14),
              const SizedBox(width: 4),
              Text(
                manga.score.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
