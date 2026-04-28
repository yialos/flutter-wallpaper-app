/// Target screen for wallpaper setting
/// Requirements: 5.1, 5.2, 5.3
enum WallpaperTarget {
  /// Home screen only
  homeScreen,

  /// Lock screen only
  lockScreen,

  /// Both home and lock screens
  both,
}

/// Extension for WallpaperTarget
extension WallpaperTargetExtension on WallpaperTarget {
  /// Get display name in Vietnamese
  String get displayName {
    switch (this) {
      case WallpaperTarget.homeScreen:
        return 'Màn hình chính';
      case WallpaperTarget.lockScreen:
        return 'Màn hình khóa';
      case WallpaperTarget.both:
        return 'Cả hai';
    }
  }
}
