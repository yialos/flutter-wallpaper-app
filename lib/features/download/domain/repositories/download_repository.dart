import '../../../browse/domain/entities/entities.dart';
import '../entities/download_progress.dart';

/// Repository interface for download operations
/// Requirements: 4.1, 4.2, 4.3
abstract class DownloadRepository {
  /// Download wallpaper with progress tracking
  ///
  /// [wallpaper] - Wallpaper to download
  ///
  /// Returns stream of download progress
  Stream<DownloadProgress> downloadWallpaper(Wallpaper wallpaper);

  /// Get download path for a wallpaper
  ///
  /// [wallpaperId] - Wallpaper unique identifier
  ///
  /// Returns local file path if downloaded, null otherwise
  Future<String?> getDownloadPath(String wallpaperId);
}
