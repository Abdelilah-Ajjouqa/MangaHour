import 'package:flutter/material.dart';
import '../../../../core/widgets/shimmer_skeleton.dart';
import '../../../../core/widgets/app_horizontal_list.dart';
import '../../../../core/widgets/section_header.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SectionHeader(title: 'شائع الآن', onViewAll: () {}),
        ),
        SliverToBoxAdapter(
          child: AppHorizontalList<int>(
            items: const [1, 2, 3], // Dummy items to render 3 skeletons
            height: 280,
            itemBuilder: (context, item, index) => const ShimmerSkeleton(width: 180, height: 280),
          ),
        ),
        SliverToBoxAdapter(
          child: SectionHeader(title: 'الأفضل', onViewAll: () {}),
        ),
        SliverToBoxAdapter(
          child: AppHorizontalList<int>(
            items: const [1, 2, 3, 4], 
            height: 220,
            itemBuilder: (context, item, index) => const ShimmerSkeleton(width: 120, height: 220),
          ),
        ),
        SliverToBoxAdapter(
          child: SectionHeader(title: 'تصنيفات', onViewAll: () {}),
        ),
        SliverToBoxAdapter(
          child: AppHorizontalList<int>(
            items: const [1, 2, 3], 
            height: 80,
            itemBuilder: (context, item, index) => const ShimmerSkeleton(width: 140, height: 80),
          ),
        ),
        const SliverToBoxAdapter(
          child: SectionHeader(title: 'مقترحات لك'),
        ),
        SliverToBoxAdapter(
          child: AppHorizontalList<int>(
            items: const [1, 2, 3], 
            height: 280,
            itemBuilder: (context, item, index) => const ShimmerSkeleton(width: 180, height: 280),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24.0)),
      ],
    );
  }
}
