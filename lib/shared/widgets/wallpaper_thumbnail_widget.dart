import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/features/browse/domain/entities/wallpaper.dart';
import 'package:wallpaper_app/shared/widgets/image_loading_error_widget.dart';
import 'package:wallpaper_app/shared/widgets/shimmer_placeholder.dart';

/// Widget to display a wallpaper thumbnail with caching
class WallpaperThumbnailWidget extends StatelessWidget {
  final Wallpaper wallpaper;
  final VoidCallback? onTap;
  final double aspectRatio;
  final BorderRadius? borderRadius;

  const WallpaperThumbnailWidget({
    super.key,
    required this.wallpaper,
    this.onTap,
    this.aspectRatio = 9 / 16,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Create semantic label for screen readers
    final categoryText = wallpaper.categories.isNotEmpty
        ? wallpaper.categories.first
        : 'không có danh mục';
    final semanticLabel =
        'Hình nền ${wallpaper.title}, '
        'độ phân giải ${wallpaper.resolution.width}x${wallpaper.resolution.height}, '
        '$categoryText';

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: true,
      child: RepaintBoundary(
        child: GestureDetector(
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Hero(
              tag: 'wallpaper_${wallpaper.id}',
              child: ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: wallpaper.thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ShimmerPlaceholder(),
                  errorWidget: (context, url, error) => ImageLoadingErrorWidget(
                    onRetry: () {
                      // Force reload by clearing cache for this image
                      CachedNetworkImage.evictFromCache(url);
                    },
                  ),
                  // Performance optimizations
                  memCacheWidth: 400, // Limit memory cache size
                  maxWidthDiskCache: 800, // Limit disk cache size
                  fadeInDuration: const Duration(milliseconds: 200),
                  fadeOutDuration: const Duration(milliseconds: 100),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
