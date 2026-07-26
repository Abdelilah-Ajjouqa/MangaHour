import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';

class ChaptersTabWidget extends StatelessWidget {
  const ChaptersTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate some mock chapters
    final chapters = List.generate(20, (index) => 20 - index);

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0, bottom: 100.0),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapterNumber = chapters[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          title: Text(
            AppLocalizations.of(context)!.chapterPrefix(chapterNumber.toString()),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '22 أكتوبر 2023', // Mock date
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.download_rounded, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                onPressed: () {},
              ),
            ],
          ),
          onTap: () {
            // Open Reader
          },
        );
      },
    );
  }
}
