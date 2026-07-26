import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/entities/manga_entity.dart';
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
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.24),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.noOfflineContent,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.connectInternetToDownload,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
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
                AppLocalizations.of(context)!.downloadedManga,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
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
