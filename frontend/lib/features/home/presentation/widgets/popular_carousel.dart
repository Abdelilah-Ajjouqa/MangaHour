import 'package:flutter/material.dart';
import '../../domain/entities/manga_entity.dart';
import 'popular_manga_card.dart';

class PopularCarousel extends StatelessWidget {
  final List<MangaEntity> mangas;

  const PopularCarousel({super.key, required this.mangas});

  @override
  Widget build(BuildContext context) {
    if (mangas.isEmpty) {
      return const SizedBox(height: 220, child: Center(child: Text('لا توجد بيانات', style: TextStyle(color: Colors.white))));
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: mangas.length,
        itemBuilder: (context, index) {
          final manga = mangas[index];
          return Padding(
            padding: EdgeInsets.only(left: index == mangas.length - 1 ? 0 : 12.0),
            child: SizedBox(
              width: 120, // Fixed width for each card
              child: PopularMangaCard(manga: manga, index: index),
            ),
          );
        },
      ),
    );
  }
}
