import '../../../browse/domain/entities/entities.dart';
import '../entities/entities.dart';
import '../repositories/download_repository.dart';

/// Use case for downloading wallpapers with progress tracking
/// Requirements: 4.1, 4.2, 4.3, 4.4, 4.5
class DownloadWallpaperUseCase {
  final DownloadRepository _repository;

  const DownloadWallpaperUseCase(this._repository);

  /// Execute the use case to download a wallpaper
  ///
  /// [wallpaper] - Wallpaper to download
  ///
  /// Returns stream of download progress
  Stream<DownloadProgress> execute(Wallpaper wallpaper) {
    return _repository.downloadWallpaper(wallpaper);
  }

  /// Get the download path for a wallpaper if it exists
  ///
  /// [wallpaperId] - Wallpaper unique identifier
  ///
  /// Returns local file path if downloaded, null otherwise
  Future<String?> getDownloadPath(String wallpaperId) async {
    return await _repository.getDownloadPath(wallpaperId);
  }
}
