import 'package:flutter/material.dart';
import '../../domain/entities/manga_entity.dart';
import 'trending_manga_card.dart';

class TrendingCarousel extends StatelessWidget {
  final List<MangaEntity> mangas;

  const TrendingCarousel({super.key, required this.mangas});

  @override
  Widget build(BuildContext context) {
    if (mangas.isEmpty) {
      return const SizedBox(height: 280, child: Center(child: Text('لا توجد بيانات', style: TextStyle(color: Colors.white))));
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: mangas.length,
        itemBuilder: (context, index) {
          final manga = mangas[index];
          return Padding(
            padding: EdgeInsets.only(left: index == mangas.length - 1 ? 0 : 12.0),
            child: TrendingMangaCard(manga: manga),
          );
        },
      ),
    );
  }
}
