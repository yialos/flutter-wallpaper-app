import 'package:share_plus/share_plus.dart';
import 'package:wallpaper_app/features/browse/domain/entities/wallpaper.dart';
import '../repositories/share_repository.dart';

/// Use case for sharing a wallpaper
class ShareWallpaperUseCase {
  final ShareRepository _repository;

  ShareWallpaperUseCase(this._repository);

  /// Execute share wallpaper
  ///
  /// [wallpaper] - The wallpaper to share
  /// [imagePath] - Optional local path to downloaded image
  /// [shareImageIfAvailable] - If true, will share image file if available
  Future<ShareResult> execute({
    required Wallpaper wallpaper,
    String? imagePath,
    bool shareImageIfAvailable = true,
  }) async {
    if (shareImageIfAvailable && imagePath != null) {
      return await _repository.shareWallpaper(
        wallpaper: wallpaper,
        imagePath: imagePath,
      );
    }

    return await _repository.shareWallpaperLink(wallpaper: wallpaper);
  }
}
