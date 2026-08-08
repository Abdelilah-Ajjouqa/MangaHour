import 'package:flutter/material.dart';
import '../entities/manga_entity.dart';
import '../localization/app_localizations.dart';
import 'manga_grid_view.dart';

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
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.noOfflineContent,
                style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
            )
          : MangaGridView(items: mangaList),
    );
  }
}
