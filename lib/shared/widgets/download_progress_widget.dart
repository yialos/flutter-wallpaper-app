import 'package:flutter/material.dart';

/// Widget to display download progress
class DownloadProgressWidget extends StatelessWidget {
  final double progress;
  final String? message;
  final VoidCallback? onCancel;

  const DownloadProgressWidget({
    super.key,
    required this.progress,
    this.message,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message ?? 'Đang tải xuống...',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$percentage%',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (onCancel != null) ...[
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onCancel,
                  tooltip: 'Hủy',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Compact version of download progress for inline display
class CompactDownloadProgressWidget extends StatelessWidget {
  final double progress;
  final double size;

  const CompactDownloadProgressWidget({
    super.key,
    required this.progress,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 2.0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
