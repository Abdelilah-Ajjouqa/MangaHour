import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/manga_detail_entity.dart';

class DetailsTabWidget extends StatefulWidget {
  final MangaDetailEntity mangaDetail;

  const DetailsTabWidget({super.key, required this.mangaDetail});

  @override
  State<DetailsTabWidget> createState() => _DetailsTabWidgetState();
}

class _DetailsTabWidgetState extends State<DetailsTabWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildStatsRow(),
        const SizedBox(height: 24),
        _buildSynopsisSection(),
        const SizedBox(height: 100), // padding for bottom button
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatBox(
          icon: Icons.star_rounded,
          value: widget.mangaDetail.score > 0 ? widget.mangaDetail.score.toString() : AppLocalizations.of(context)!.unknown,
          label: AppLocalizations.of(context)!.rating,
        ),
        _buildStatBox(
          icon: Icons.format_list_bulleted_rounded,
          value: widget.mangaDetail.totalChapters > 0 ? widget.mangaDetail.totalChapters.toString() : AppLocalizations.of(context)!.unknown,
          label: AppLocalizations.of(context)!.chaptersCount,
        ),
        _buildStatBox(
          icon: Icons.info_outline_rounded,
          value: widget.mangaDetail.status,
          label: AppLocalizations.of(context)!.status,
        ),
      ],
    );
  }

  Widget _buildStatBox({required IconData icon, required String value, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSynopsisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.synopsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.mangaDetail.synopsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                maxLines: isExpanded ? null : 4,
                overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      isExpanded ? AppLocalizations.of(context)!.showLess : AppLocalizations.of(context)!.readMore,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
