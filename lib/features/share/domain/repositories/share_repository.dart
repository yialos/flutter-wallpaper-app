import 'package:share_plus/share_plus.dart';
import 'package:wallpaper_app/features/browse/domain/entities/wallpaper.dart';

/// Repository interface for sharing wallpapers
abstract class ShareRepository {
  /// Share a single wallpaper
  Future<ShareResult> shareWallpaper({
    required Wallpaper wallpaper,
    String? imagePath,
  });

  /// Share wallpaper link only
  Future<ShareResult> shareWallpaperLink({required Wallpaper wallpaper});

  /// Share multiple wallpapers
  Future<ShareResult> shareMultipleWallpapers({
    required List<Wallpaper> wallpapers,
    List<String>? imagePaths,
  });
}
