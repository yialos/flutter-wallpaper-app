import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/accessibility_utils.dart';
import '../../../browse/domain/entities/wallpaper.dart';
import '../notifiers/download_notifier.dart';

/// Download button widget with progress indicator
/// Requirements: 4.1, 4.3, 4.4, 4.5
class DownloadButtonWidget extends ConsumerWidget {
  final Wallpaper wallpaper;
  final bool showLabel;

  const DownloadButtonWidget({
    super.key,
    required this.wallpaper,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadState = ref.watch(downloadStateProvider(wallpaper.id));

    if (downloadState == null) {
      // Not downloading
      return _buildDownloadButton(context, ref);
    }

    if (downloadState.isDownloading) {
      // Downloading - show progress
      return _buildProgressIndicator(context, downloadState);
    }

    if (downloadState.hasError) {
      // Error - show retry button
      return _buildRetryButton(context, ref, downloadState.error!);
    }

    if (downloadState.isCompleted) {
      // Completed - show success
      return _buildCompletedButton(context);
    }

    return _buildDownloadButton(context, ref);
  }

  Widget _buildDownloadButton(BuildContext context, WidgetRef ref) {
    if (showLabel) {
      return Semantics(
        label: 'Tải xuống hình nền',
        hint: 'Nhấn để tải xuống hình nền này',
        button: true,
        child: InkWell(
          onTap: () => _onDownload(context, ref),
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
                  child: const Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tải xuống',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: 'Tải xuống hình nền',
      hint: 'Nhấn để tải xuống hình nền này',
      button: true,
      child: IconButton(
        icon: const Icon(Icons.download),
        onPressed: () => _onDownload(context, ref),
        tooltip: 'Tải xuống',
      ),
    ).withTouchTarget();
  }

  Widget _buildProgressIndicator(BuildContext context, DownloadState state) {
    if (showLabel) {
      return Semantics(
        label: 'Đang tải xuống',
        value: '${state.progressPercentage}% hoàn thành',
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        value: state.progress,
                        strokeWidth: 3,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '${state.progressPercentage}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Đang tải...',
                style: TextStyle(
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

    return Semantics(
      label: 'Đang tải xuống',
      value: '${state.progressPercentage}% hoàn thành',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: state.progress,
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context, WidgetRef ref, String error) {
    if (showLabel) {
      return Semantics(
        label: 'Thử lại tải xuống',
        hint: 'Nhấn để thử lại tải xuống hình nền',
        button: true,
        child: InkWell(
          onTap: () => _onRetry(context, ref),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thử lại',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: 'Thử lại tải xuống',
      hint: 'Nhấn để thử lại tải xuống hình nền',
      button: true,
      child: IconButton(
        icon: const Icon(Icons.refresh, color: Colors.red),
        onPressed: () => _onRetry(context, ref),
        tooltip: 'Thử lại',
      ),
    ).withTouchTarget();
  }

  Widget _buildCompletedButton(BuildContext context) {
    if (showLabel) {
      return Semantics(
        label: 'Đã tải xuống',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Đã tải',
                style: TextStyle(
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

    return Semantics(
      label: 'Đã tải xuống',
      child: const Icon(Icons.check_circle, color: Colors.green, size: 28),
    );
  }

  void _onDownload(BuildContext context, WidgetRef ref) {
    ref.read(downloadNotifierProvider.notifier).downloadWallpaper(wallpaper);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đang tải xuống...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onRetry(BuildContext context, WidgetRef ref) {
    ref.read(downloadNotifierProvider.notifier).retryDownload(wallpaper);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đang thử lại...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
