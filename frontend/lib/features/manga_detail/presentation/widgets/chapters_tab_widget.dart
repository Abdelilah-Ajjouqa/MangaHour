import 'package:flutter/material.dart';

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
            'الفصل $chapterNumber',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '22 أكتوبر 2023', // Mock date
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.download_rounded, color: Colors.grey),
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
