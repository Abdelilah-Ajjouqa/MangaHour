import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const ShimmerSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black, // Color required for Shimmer to mask properly
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
