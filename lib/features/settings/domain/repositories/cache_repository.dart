import 'dart:io';

/// Repository interface for cache operations
/// Requirements: 7.1, 7.2, 7.3, 7.4, 7.5
abstract class CacheRepository {
  /// Get cached wallpaper file
  ///
  /// [wallpaperId] - Wallpaper unique identifier
  ///
  /// Returns cached file if exists, null otherwise
  Future<File?> getCachedWallpaper(String wallpaperId);

  /// Cache wallpaper image
  ///
  /// [wallpaperId] - Wallpaper unique identifier
  /// [imageFile] - Image file to cache
  Future<void> cacheWallpaper(String wallpaperId, File imageFile);

  /// Clear all cached wallpapers
  Future<void> clearCache();

  /// Get current cache size in bytes
  ///
  /// Returns total cache size
  Future<int> getCacheSize();

  /// Evict oldest cached items if cache size exceeds limit
  Future<void> evictOldestIfNeeded();
}
