import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_dimens.dart';
import '../entities/manga_entity.dart';
import 'manga_cover_image.dart';

class MangaGridView extends StatelessWidget {
  final List<MangaEntity> items;
  final ScrollController? controller;
  final VoidCallback? onRefresh;
  final Function(MangaEntity)? onItemTap;
  final EdgeInsetsGeometry? padding;

  const MangaGridView({
    super.key,
    required this.items,
    this.controller,
    this.onRefresh,
    this.onItemTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final grid = GridView.builder(
      controller: controller,
      padding: padding ?? const EdgeInsets.all(AppDimens.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppDimens.gridCrossAxisCount,
        childAspectRatio: AppDimens.gridChildAspectRatio,
        crossAxisSpacing: AppDimens.gridCrossAxisSpacing,
        mainAxisSpacing: AppDimens.gridMainAxisSpacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final manga = items[index];
        return GestureDetector(
          onTap: () {
            if (onItemTap != null) {
              onItemTap!(manga);
            } else {
              context.push('/manga/${manga.malId}', extra: manga);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppDimens.cardRadius,
                  child: MangaCoverImage(imageUrl: manga.coverUrl),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                manga.displayTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        );
      },
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async => onRefresh!(),
        color: Theme.of(context).colorScheme.primary,
        child: grid,
      );
    }

    return grid;
  }
}
