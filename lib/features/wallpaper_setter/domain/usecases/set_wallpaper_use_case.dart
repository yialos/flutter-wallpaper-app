import 'dart:io';
import '../entities/wallpaper_target.dart';
import '../repositories/wallpaper_setter_repository.dart';

/// Use case for setting wallpaper
/// Requirements: 5.1, 5.2, 5.3
class SetWallpaperUseCase {
  final WallpaperSetterRepository _repository;

  SetWallpaperUseCase(this._repository);

  /// Execute the use case
  ///
  /// [imageFile] - Image file to set as wallpaper
  /// [target] - Target screen (home, lock, or both)
  ///
  /// Returns true if successful, false otherwise
  Future<bool> execute(File imageFile, WallpaperTarget target) async {
    return await _repository.setWallpaper(imageFile, target);
  }

  /// Check if platform supports wallpaper setting
  bool isSupported() {
    return _repository.isSupported();
  }

  /// Get supported targets for current platform
  List<WallpaperTarget> getSupportedTargets() {
    return _repository.getSupportedTargets();
  }
}
