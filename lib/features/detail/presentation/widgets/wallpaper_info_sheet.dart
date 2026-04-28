import 'package:flutter/material.dart';
import '../../../browse/domain/entities/wallpaper.dart';

/// Bottom sheet showing wallpaper information
/// Requirements: 1.3
class WallpaperInfoSheet extends StatelessWidget {
  final Wallpaper wallpaper;

  const WallpaperInfoSheet({super.key, required this.wallpaper});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            wallpaper.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Info rows
          _buildInfoRow(
            context,
            icon: Icons.person_outline,
            label: 'Tác giả',
            value: wallpaper.author ?? 'Không rõ',
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            context,
            icon: Icons.aspect_ratio,
            label: 'Độ phân giải',
            value:
                '${wallpaper.resolution.width} x ${wallpaper.resolution.height}',
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            context,
            icon: Icons.straighten,
            label: 'Tỷ lệ khung hình',
            value: '${wallpaper.resolution.aspectRatio.toStringAsFixed(2)}:1',
          ),
          const SizedBox(height: 12),

          if (wallpaper.categories.isNotEmpty)
            _buildInfoRow(
              context,
              icon: Icons.category_outlined,
              label: 'Danh mục',
              value: wallpaper.categories.join(', '),
            ),

          if (wallpaper.categories.isNotEmpty) const SizedBox(height: 12),

          _buildInfoRow(
            context,
            icon: Icons.calendar_today_outlined,
            label: 'Ngày tạo',
            value: _formatDate(wallpaper.createdAt),
          ),

          // Description if available
          if (wallpaper.description != null &&
              wallpaper.description!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Mô tả',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              wallpaper.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              Flexible(
                child: Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hôm nay';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      // Simple date formatting without intl package
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}
