import 'dart:io';
import '../entities/wallpaper_target.dart';

/// Repository interface for wallpaper setting operations
/// Requirements: 5.1, 5.2, 5.3
abstract class WallpaperSetterRepository {
  /// Set wallpaper from file
  ///
  /// [imageFile] - Image file to set as wallpaper
  /// [target] - Target screen (home, lock, or both)
  ///
  /// Returns true if successful, false otherwise
  Future<bool> setWallpaper(File imageFile, WallpaperTarget target);

  /// Check if platform supports wallpaper setting
  ///
  /// Returns true if supported, false otherwise
  bool isSupported();

  /// Get supported targets for current platform
  ///
  /// Returns list of supported targets
  List<WallpaperTarget> getSupportedTargets();
}
