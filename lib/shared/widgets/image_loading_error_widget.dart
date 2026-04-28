import 'package:flutter/material.dart';
import 'package:wallpaper_app/core/constants/app_strings.dart';

/// Widget to display when image loading fails
class ImageLoadingErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final double? width;
  final double? height;

  const ImageLoadingErrorWidget({
    super.key,
    this.onRetry,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            AppStrings.errorImageLoad,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text(AppStrings.retry)),
          ],
        ],
      ),
    );
  }
}
