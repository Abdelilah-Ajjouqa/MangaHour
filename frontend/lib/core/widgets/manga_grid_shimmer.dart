import 'package:flutter/material.dart';
import '../constants/app_dimens.dart';
import 'shimmer_skeleton.dart';

class MangaGridShimmer extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const MangaGridShimmer({
    super.key,
    this.itemCount = 6,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(AppDimens.paddingMedium),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppDimens.gridCrossAxisCount,
        childAspectRatio: AppDimens.gridChildAspectRatio,
        crossAxisSpacing: AppDimens.gridCrossAxisSpacing,
        mainAxisSpacing: AppDimens.gridMainAxisSpacing,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ShimmerSkeleton(
                borderRadius: AppDimens.cardBorderRadius,
              ),
            ),
            SizedBox(height: 6),
            ShimmerSkeleton(
              height: 12,
              borderRadius: 4,
            ),
            SizedBox(height: 4),
            ShimmerSkeleton(
              width: 60,
              height: 10,
              borderRadius: 4,
            ),
          ],
        );
      },
    );
  }
}
