import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/features/browse/domain/entities/wallpaper.dart';
import 'add_to_collection_bottom_sheet.dart';

/// Button to add wallpaper to collection
class AddToCollectionButton extends ConsumerWidget {
  final Wallpaper wallpaper;
  final bool showLabel;
  final Color? iconColor;
  final double? iconSize;

  const AddToCollectionButton({
    super.key,
    required this.wallpaper,
    this.showLabel = false,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (showLabel) {
      return ElevatedButton.icon(
        onPressed: () => _showBottomSheet(context),
        icon: Icon(Icons.add_to_photos, size: iconSize ?? 20, color: iconColor),
        label: const Text('Thêm vào bộ sưu tập'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );
    }

    return IconButton(
      onPressed: () => _showBottomSheet(context),
      icon: Icon(
        Icons.add_to_photos,
        size: iconSize ?? 24,
        color: iconColor ?? Theme.of(context).iconTheme.color,
      ),
      tooltip: 'Thêm vào bộ sưu tập',
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddToCollectionBottomSheet(wallpaper: wallpaper),
    );
  }
}
