import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../browse/domain/entities/wallpaper.dart';
import '../../../download/presentation/widgets/download_button_widget.dart';
import '../../../share/presentation/widgets/share_button.dart';
import '../../../collections/presentation/widgets/add_to_collection_button.dart';
import 'favorite_button_widget.dart';

/// Action buttons for wallpaper detail page
/// Requirements: 4.1, 5.1, 6.1
class WallpaperActionButtons extends ConsumerWidget {
  final Wallpaper wallpaper;
  final VoidCallback onResetZoom;

  const WallpaperActionButtons({
    super.key,
    required this.wallpaper,
    required this.onResetZoom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary actions row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DownloadButtonWidget(wallpaper: wallpaper, showLabel: true),
              _ActionButton(
                icon: Icons.wallpaper,
                label: 'Đặt hình nền',
                onPressed: () => _onSetWallpaper(context),
              ),
              // Use ShareButton widget
              Expanded(
                child: Center(
                  child: ShareButton(
                    wallpaper: wallpaper,
                    showLabel: true,
                    iconColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Secondary actions row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ActionButton(
                icon: Icons.zoom_out_map,
                label: 'Reset zoom',
                onPressed: onResetZoom,
              ),
              FavoriteButtonWidget(
                wallpaper: wallpaper,
                iconSize: 28,
                showLabel: true,
              ),
              // Add to collection button
              Expanded(
                child: Center(
                  child: AddToCollectionButton(
                    wallpaper: wallpaper,
                    showLabel: true,
                    iconColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSetWallpaper(BuildContext context) {
    if (kIsWeb) {
      // Web: Show instructions dialog
      _showWebInstructions(context);
    } else {
      // Mobile/Desktop: Show "Coming soon" for now
      // TODO: Implement native wallpaper setting
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tính năng đặt hình nền sẽ được triển khai sớm'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showWebInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hướng dẫn đặt hình nền'),
        content: const Text(
          'Trình duyệt web không hỗ trợ đặt hình nền tự động.\n\n'
          'Hướng dẫn:\n'
          '1. Tải hình nền về máy (nút Download)\n'
          '2. Mở Settings trên thiết bị\n'
          '3. Chọn Wallpaper/Background\n'
          '4. Chọn hình ảnh đã tải',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}

/// Individual action button widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
