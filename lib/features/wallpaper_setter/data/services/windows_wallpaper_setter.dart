import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:ffi/ffi.dart';

/// Windows wallpaper setter using FFI
/// Requirements: 5.2, 5.3, 10.4
class WindowsWallpaperSetter {
  // Windows API constants
  static const int SPI_SETDESKWALLPAPER = 0x0014;
  static const int SPIF_UPDATEINIFILE = 0x01;
  static const int SPIF_SENDCHANGE = 0x02;

  /// Set wallpaper on Windows using SystemParametersInfoW
  static bool setWallpaper(String imagePath) {
    try {
      // Load user32.dll
      final user32 = DynamicLibrary.open('user32.dll');

      // Get SystemParametersInfoW function
      final systemParametersInfo = user32
          .lookupFunction<
            Int32 Function(Uint32, Uint32, Pointer<Utf16>, Uint32),
            int Function(int, int, Pointer<Utf16>, int)
          >('SystemParametersInfoW');

      // Convert path to UTF-16
      final pathPtr = imagePath.toNativeUtf16();

      // Call SystemParametersInfoW
      final result = systemParametersInfo(
        SPI_SETDESKWALLPAPER,
        0,
        pathPtr,
        SPIF_UPDATEINIFILE | SPIF_SENDCHANGE,
      );

      // Free memory
      malloc.free(pathPtr);

      return result != 0;
    } catch (e) {
      debugPrint('Error setting Windows wallpaper: $e');
      return false;
    }
  }
}
