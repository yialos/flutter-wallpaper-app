import '../../../browse/domain/entities/entities.dart';
import '../../../../core/utils/edge_case_handler.dart';
import '../../domain/entities/download_progress.dart';
import '../../domain/repositories/download_repository.dart';
import '../services/download_manager.dart';

/// Implementation of DownloadRepository
/// Requirements: 4.1, 4.2, 4.3
class DownloadRepositoryImpl implements DownloadRepository {
  final DownloadManager downloadManager;
  final Map<String, String> _downloadedFiles = {};

  DownloadRepositoryImpl({required this.downloadManager});

  @override
  Stream<DownloadProgress> downloadWallpaper(Wallpaper wallpaper) async* {
    try {
      // Validate image URL
      if (!EdgeCaseHandler.isValidImageUrl(wallpaper.fullResolutionUrl)) {
        yield DownloadProgress(
          wallpaperId: wallpaper.id,
          bytesReceived: 0,
          totalBytes: 0,
          status: DownloadStatus.failed,
          errorMessage: 'URL hình ảnh không hợp lệ',
        );
        return;
      }

      // Check storage availability (estimate 10MB per image)
      final hasSufficientStorage = await EdgeCaseHandler.hasSufficientStorage(
        requiredBytes: 10 * 1024 * 1024,
      );

      if (!hasSufficientStorage) {
        yield DownloadProgress(
          wallpaperId: wallpaper.id,
          bytesReceived: 0,
          totalBytes: 0,
          status: DownloadStatus.failed,
          errorMessage: 'Không đủ dung lượng lưu trữ',
        );
        return;
      }

      // Emit starting state
      yield DownloadProgress(
        wallpaperId: wallpaper.id,
        bytesReceived: 0,
        totalBytes: 0,
        status: DownloadStatus.downloading,
      );

      int lastReceived = 0;
      int lastTotal = 0;

      // Generate safe filename
      final fileName = EdgeCaseHandler.getSafeFilename(
        wallpaper.fullResolutionUrl,
      );
      final uniqueFileName =
          'wallpaper_${wallpaper.id}_${DateTime.now().millisecondsSinceEpoch}_$fileName';

      // Download file with retry logic
      final filePath = await EdgeCaseHandler.retryWithBackoff(
        operation: () => downloadManager.downloadFile(
          url: wallpaper.fullResolutionUrl,
          fileName: uniqueFileName,
          onProgress: (received, total) {
            lastReceived = received;
            lastTotal = total;
          },
        ),
        maxAttempts: 3,
      );

      // Store download path
      _downloadedFiles[wallpaper.id] = filePath;

      // Emit completed state
      yield DownloadProgress(
        wallpaperId: wallpaper.id,
        bytesReceived: lastReceived,
        totalBytes: lastTotal,
        status: DownloadStatus.completed,
      );
    } catch (e) {
      // Get user-friendly error message
      final errorMessage = EdgeCaseHandler.getUserFriendlyErrorMessage(e);

      // Emit error state
      yield DownloadProgress(
        wallpaperId: wallpaper.id,
        bytesReceived: 0,
        totalBytes: 0,
        status: DownloadStatus.failed,
        errorMessage: errorMessage,
      );
    }
  }

  @override
  Future<String?> getDownloadPath(String wallpaperId) async {
    return _downloadedFiles[wallpaperId];
  }
}
