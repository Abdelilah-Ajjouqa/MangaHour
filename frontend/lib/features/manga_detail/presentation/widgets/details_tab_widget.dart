import 'package:flutter/material.dart';
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
          icon: Icons.star,
          value: widget.mangaDetail.score.toStringAsFixed(1),
          label: 'التقييم',
        ),
        const SizedBox(width: 16),
        _buildStatBox(
          icon: Icons.menu_book,
          value: widget.mangaDetail.totalChapters > 0 ? widget.mangaDetail.totalChapters.toString() : '؟',
          label: 'عدد الفصول',
        ),
        const SizedBox(width: 16),
        _buildStatBox(
          icon: Icons.update,
          value: widget.mangaDetail.status,
          label: 'الحالة',
        ),
      ],
    );
  }

  Widget _buildStatBox({required IconData icon, required String value, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.green, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
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
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            const Text(
              'القصة',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.mangaDetail.synopsis,
                style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
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
                      isExpanded ? 'عرض أقل' : 'اقرأ المزيد',
                      style: const TextStyle(color: Colors.green, fontSize: 14),
                    ),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.green,
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
