import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../browse/domain/entities/wallpaper.dart';
import '../../domain/entities/download_progress.dart';
import '../../domain/usecases/download_wallpaper_use_case.dart';
import '../providers/download_providers.dart';

/// Download state for a single wallpaper
/// Requirements: 4.3
class DownloadState {
  final String wallpaperId;
  final bool isDownloading;
  final double progress; // 0.0 to 1.0
  final String? filePath;
  final String? error;

  const DownloadState({
    required this.wallpaperId,
    this.isDownloading = false,
    this.progress = 0.0,
    this.filePath,
    this.error,
  });

  DownloadState copyWith({
    bool? isDownloading,
    double? progress,
    String? filePath,
    String? error,
    bool clearError = false,
  }) {
    return DownloadState(
      wallpaperId: wallpaperId,
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      filePath: filePath ?? this.filePath,
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool get isCompleted => filePath != null;
  bool get hasError => error != null;
  int get progressPercentage => (progress * 100).round();
}

/// State notifier for download operations
/// Requirements: 4.1, 4.2, 4.3, 4.4, 4.5
class DownloadNotifier extends StateNotifier<Map<String, DownloadState>> {
  final DownloadWallpaperUseCase _downloadWallpaperUseCase;

  DownloadNotifier(this._downloadWallpaperUseCase) : super({});

  /// Download a wallpaper
  /// Requirements: 4.1, 4.2, 4.3
  Future<void> downloadWallpaper(Wallpaper wallpaper) async {
    final wallpaperId = wallpaper.id;

    // Initialize download state
    state = {
      ...state,
      wallpaperId: DownloadState(wallpaperId: wallpaperId, isDownloading: true),
    };

    try {
      // Listen to download progress stream
      await for (final progress in _downloadWallpaperUseCase.execute(
        wallpaper,
      )) {
        if (progress.status == DownloadStatus.downloading) {
          // Update progress
          final progressValue = progress.totalBytes > 0
              ? progress.bytesReceived / progress.totalBytes
              : 0.0;

          state = {
            ...state,
            wallpaperId: state[wallpaperId]!.copyWith(progress: progressValue),
          };
        } else if (progress.status == DownloadStatus.completed) {
          // Download completed - get file path from repository
          final filePath = await _downloadWallpaperUseCase.getDownloadPath(
            wallpaperId,
          );

          state = {
            ...state,
            wallpaperId: state[wallpaperId]!.copyWith(
              isDownloading: false,
              filePath: filePath,
              progress: 1.0,
            ),
          };
        } else if (progress.status == DownloadStatus.failed) {
          // Download failed
          state = {
            ...state,
            wallpaperId: state[wallpaperId]!.copyWith(
              isDownloading: false,
              error: progress.errorMessage ?? 'Lỗi không xác định',
            ),
          };
        }
      }
    } catch (e) {
      // Update state with error
      state = {
        ...state,
        wallpaperId: state[wallpaperId]!.copyWith(
          isDownloading: false,
          error: e.toString(),
        ),
      };
    }
  }

  /// Retry a failed download
  /// Requirements: 4.5
  Future<void> retryDownload(Wallpaper wallpaper) async {
    // Clear error and retry
    final wallpaperId = wallpaper.id;
    if (state[wallpaperId] != null) {
      state = {
        ...state,
        wallpaperId: state[wallpaperId]!.copyWith(clearError: true),
      };
    }
    await downloadWallpaper(wallpaper);
  }

  /// Clear download state for a wallpaper
  void clearDownloadState(String wallpaperId) {
    final newState = Map<String, DownloadState>.from(state);
    newState.remove(wallpaperId);
    state = newState;
  }

  /// Get download state for a specific wallpaper
  DownloadState? getDownloadState(String wallpaperId) {
    return state[wallpaperId];
  }
}

/// Provider for DownloadNotifier
/// Requirements: 4.1, 4.2, 4.3, 4.4, 4.5
final downloadNotifierProvider =
    StateNotifierProvider<DownloadNotifier, Map<String, DownloadState>>((ref) {
      final downloadWallpaperUseCase = ref.watch(
        downloadWallpaperUseCaseProvider,
      );
      return DownloadNotifier(downloadWallpaperUseCase);
    });

/// Provider for getting download state of a specific wallpaper
final downloadStateProvider = Provider.family<DownloadState?, String>((
  ref,
  wallpaperId,
) {
  final downloadStates = ref.watch(downloadNotifierProvider);
  return downloadStates[wallpaperId];
});
