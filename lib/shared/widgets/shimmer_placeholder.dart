import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder for loading thumbnails
class ShimmerPlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

/// Shimmer placeholder specifically for wallpaper thumbnails in grid
class WallpaperThumbnailShimmer extends StatelessWidget {
  final double aspectRatio;

  const WallpaperThumbnailShimmer({super.key, this.aspectRatio = 9 / 16});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: const ShimmerPlaceholder(),
    );
  }
}
