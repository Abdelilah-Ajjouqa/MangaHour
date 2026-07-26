import 'package:flutter/material.dart';
import '../../../../core/widgets/shimmer_skeleton.dart';
import '../../../../core/widgets/app_horizontal_list.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/localization/app_localizations.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SectionHeader(title: AppLocalizations.of(context)!.trendingNow, onViewAll: () {}),
        ),
        SliverToBoxAdapter(
          child: AppHorizontalList<int>(
            items: const [1, 2, 3], // Dummy items to render 3 skeletons
            height: 280,
            itemBuilder: (context, item, index) => const ShimmerSkeleton(width: 180, height: 280),
          ),
        ),
        SliverToBoxAdapter(
          child: SectionHeader(title: AppLocalizations.of(context)!.best, onViewAll: () {}),
        ),
        SliverToBoxAdapter(
          child: AppHorizontalList<int>(
            items: const [1, 2, 3, 4], 
            height: 220,
            itemBuilder: (context, item, index) => const ShimmerSkeleton(width: 120, height: 220),
          ),
        ),
        SliverToBoxAdapter(
          child: SectionHeader(title: AppLocalizations.of(context)!.genres, onViewAll: () {}),
        ),
        SliverToBoxAdapter(
          child: AppHorizontalList<int>(
            items: const [1, 2, 3], 
            height: 80,
            itemBuilder: (context, item, index) => const ShimmerSkeleton(width: 140, height: 80),
          ),
        ),
        SliverToBoxAdapter(
          child: SectionHeader(title: AppLocalizations.of(context)!.recommendedForYou),
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
