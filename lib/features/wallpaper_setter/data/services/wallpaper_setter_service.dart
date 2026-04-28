import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/wallpaper_target.dart';

/// Abstract service for platform-specific wallpaper setting
/// Requirements: 5.1, 5.2, 5.3
abstract class WallpaperSetterService {
  /// Set wallpaper from file
  Future<bool> setWallpaper(File imageFile, WallpaperTarget target);

  /// Check if platform supports wallpaper setting
  bool isSupported();

  /// Get supported targets for current platform
  List<WallpaperTarget> getSupportedTargets();
}

/// Factory for creating platform-specific wallpaper setter
/// Requirements: 5.1, 5.2, 5.3
class WallpaperSetterFactory {
  static WallpaperSetterService create() {
    if (kIsWeb) {
      return WebWallpaperSetterService();
    } else if (Platform.isAndroid) {
      return AndroidWallpaperSetterService();
    } else if (Platform.isIOS) {
      return IOSWallpaperSetterService();
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return DesktopWallpaperSetterService();
    } else {
      return UnsupportedWallpaperSetterService();
    }
  }
}

/// Web implementation (download only)
/// Requirements: 5.2, 10.3
class WebWallpaperSetterService implements WallpaperSetterService {
  @override
  Future<bool> setWallpaper(File imageFile, WallpaperTarget target) async {
    // Web doesn't support setting wallpaper directly
    // User needs to download and set manually
    return false;
  }

  @override
  bool isSupported() => false;

  @override
  List<WallpaperTarget> getSupportedTargets() => [];
}

/// Android implementation using MethodChannel
/// Requirements: 5.2, 5.3, 10.1
class AndroidWallpaperSetterService implements WallpaperSetterService {
  static const MethodChannel _channel = MethodChannel(
    'com.wallpaperapp/wallpaper',
  );

  @override
  Future<bool> setWallpaper(File imageFile, WallpaperTarget target) async {
    try {
      if (!imageFile.existsSync()) {
        return false;
      }

      final String targetString = _getTargetString(target);
      final result = await _channel.invokeMethod<bool>('setWallpaper', {
        'imagePath': imageFile.absolute.path,
        'target': targetString,
      });

      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Error setting wallpaper: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return false;
    }
  }

  String _getTargetString(WallpaperTarget target) {
    switch (target) {
      case WallpaperTarget.homeScreen:
        return 'homeScreen';
      case WallpaperTarget.lockScreen:
        return 'lockScreen';
      case WallpaperTarget.both:
        return 'both';
    }
  }

  @override
  bool isSupported() => true;

  @override
  List<WallpaperTarget> getSupportedTargets() => [
    WallpaperTarget.homeScreen,
    WallpaperTarget.lockScreen,
    WallpaperTarget.both,
  ];
}

/// iOS implementation (save to Photos)
/// Requirements: 5.2, 5.3, 10.2
class IOSWallpaperSetterService implements WallpaperSetterService {
  static const MethodChannel _channel = MethodChannel(
    'com.wallpaperapp/wallpaper',
  );

  @override
  Future<bool> setWallpaper(File imageFile, WallpaperTarget target) async {
    try {
      if (!imageFile.existsSync()) {
        return false;
      }

      final result = await _channel.invokeMethod<bool>('saveToPhotos', {
        'imagePath': imageFile.absolute.path,
      });

      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Error saving to photos: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return false;
    }
  }

  @override
  bool isSupported() => true;

  @override
  List<WallpaperTarget> getSupportedTargets() => [
    WallpaperTarget.homeScreen,
    WallpaperTarget.lockScreen,
    WallpaperTarget.both,
  ];
}

/// Desktop implementation (Windows/macOS/Linux)
/// Requirements: 5.2, 5.3, 10.4
class DesktopWallpaperSetterService implements WallpaperSetterService {
  static const MethodChannel _channel = MethodChannel(
    'com.wallpaperapp/wallpaper',
  );

  @override
  Future<bool> setWallpaper(File imageFile, WallpaperTarget target) async {
    try {
      if (!imageFile.existsSync()) {
        return false;
      }

      // For Windows, use FFI directly
      if (Platform.isWindows) {
        return _setWindowsWallpaper(imageFile);
      }

      // For macOS and Linux, use MethodChannel
      final result = await _channel.invokeMethod<bool>('setDesktopWallpaper', {
        'imagePath': imageFile.absolute.path,
      });

      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Error setting desktop wallpaper: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return false;
    }
  }

  bool _setWindowsWallpaper(File imageFile) {
    try {
      // Import Windows wallpaper setter
      // Note: This requires ffi package
      if (Platform.isWindows) {
        // Use Process to call PowerShell as a fallback
        final result = Process.runSync('powershell', [
          '-Command',
          '''
            Add-Type -TypeDefinition @"
            using System;
            using System.Runtime.InteropServices;
            public class Wallpaper {
                [DllImport("user32.dll", CharSet = CharSet.Auto)]
                public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
            }
"@
            [Wallpaper]::SystemParametersInfo(20, 0, "${imageFile.absolute.path}", 3)
            ''',
        ]);
        return result.exitCode == 0;
      }
      return false;
    } catch (e) {
      debugPrint('Error setting Windows wallpaper: $e');
      return false;
    }
  }

  @override
  bool isSupported() => true;

  @override
  List<WallpaperTarget> getSupportedTargets() => [WallpaperTarget.homeScreen];
}

/// Unsupported platform fallback
class UnsupportedWallpaperSetterService implements WallpaperSetterService {
  @override
  Future<bool> setWallpaper(File imageFile, WallpaperTarget target) async {
    return false;
  }

  @override
  bool isSupported() => false;

  @override
  List<WallpaperTarget> getSupportedTargets() => [];
}
