import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/manga_cover_image.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/entities/manga_entity.dart';

class TrendingMangaCard extends StatelessWidget {
  final MangaEntity manga;

  const TrendingMangaCard({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/manga/${manga.malId}', extra: manga);
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: MangaCoverImage(
                imageUrl: manga.coverUrl,
                borderRadius: 0, // Already clipped by parent Container
              ),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12, right: 12, left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (manga.chapters != null)
                    Text(
                      AppLocalizations.of(context)!.chapterPrefix(manga.chapters.toString()),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              top: 8, right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: manga.isPublishing ? Theme.of(context).colorScheme.error : AppColors.overlay,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: manga.isPublishing 
                  ? Text(AppLocalizations.of(context)!.newBadge, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: AppColors.star, size: 14),
                        const SizedBox(width: 4),
                        Text(manga.score.toStringAsFixed(1), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
