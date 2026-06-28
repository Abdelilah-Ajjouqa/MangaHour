import 'package:flutter/material.dart';
import '../../domain/entities/manga_entity.dart';
import 'popular_manga_card.dart';

class PopularGrid extends StatelessWidget {
  final List<MangaEntity> mangas;

  const PopularGrid({super.key, required this.mangas});

  @override
  Widget build(BuildContext context) {
    if (mangas.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('لا توجد بيانات', style: TextStyle(color: Colors.white))),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final manga = mangas[index];
          return PopularMangaCard(manga: manga, index: index);
        },
        childCount: mangas.length,
      ),
    );
  }
}
