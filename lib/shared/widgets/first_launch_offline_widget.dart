import 'package:flutter/material.dart';
import '../../core/utils/edge_case_handler.dart';

/// Widget displayed when app is launched for the first time without internet
/// Requirements: 8.1, 11.2
class FirstLaunchOfflineWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const FirstLaunchOfflineWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(Icons.cloud_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),

            // Title
            Text(
              'Không có kết nối internet',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Message
            Text(
              EdgeCaseHandler.getFirstLaunchOfflineMessage(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Retry button
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Help text
            Text(
              'Kiểm tra:\n'
              '• Kết nối Wi-Fi hoặc dữ liệu di động\n'
              '• Cài đặt tường lửa\n'
              '• Chế độ máy bay',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
