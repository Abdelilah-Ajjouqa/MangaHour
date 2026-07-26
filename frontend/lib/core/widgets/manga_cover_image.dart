import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MangaCoverImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;

  const MangaCoverImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppColors.surfaceVariant,
      ),
      clipBehavior: Clip.antiAlias,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        placeholder: (context, url) => Container(color: AppColors.surfaceVariant),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.broken_image, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
