import 'package:flutter/material.dart';

class GenresCarousel extends StatelessWidget {
  const GenresCarousel({super.key});

  final List<String> genres = const [
    "أكشن",
    "رومانسي",
    "كوميدي",
    "خيال",
    "دراما",
    "رعب",
    "غموض",
    "مغامرات",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Padding(
            padding: EdgeInsets.only(left: index == genres.length - 1 ? 0 : 12.0),
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withValues(alpha: 0.6),
                    Colors.black87,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                genre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
