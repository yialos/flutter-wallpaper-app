import 'package:share_plus/share_plus.dart';
import 'package:wallpaper_app/features/browse/domain/entities/wallpaper.dart';
import 'package:wallpaper_app/features/share/domain/repositories/share_repository.dart';
import '../services/share_service.dart';

/// Implementation of ShareRepository
class ShareRepositoryImpl implements ShareRepository {
  final ShareService _shareService;

  ShareRepositoryImpl({required ShareService shareService})
    : _shareService = shareService;

  @override
  Future<ShareResult> shareWallpaper({
    required Wallpaper wallpaper,
    String? imagePath,
  }) async {
    return await _shareService.shareWallpaper(
      wallpaper: wallpaper,
      imagePath: imagePath,
    );
  }

  @override
  Future<ShareResult> shareWallpaperLink({required Wallpaper wallpaper}) async {
    return await _shareService.shareWallpaperLink(wallpaper: wallpaper);
  }

  @override
  Future<ShareResult> shareMultipleWallpapers({
    required List<Wallpaper> wallpapers,
    List<String>? imagePaths,
  }) async {
    return await _shareService.shareMultipleWallpapers(
      wallpapers: wallpapers,
      imagePaths: imagePaths,
    );
  }
}
