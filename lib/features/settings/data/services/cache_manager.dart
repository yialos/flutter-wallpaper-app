import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/app_constants.dart';

/// Custom cache manager for wallpaper images
/// Requirements: 7.1, 7.3, 7.4
class WallpaperCacheManager extends CacheManager {
  static const key = 'wallpaper_cache';

  static WallpaperCacheManager? _instance;

  factory WallpaperCacheManager() {
    _instance ??= WallpaperCacheManager._();
    return _instance!;
  }

  WallpaperCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: AppConstants.maxCacheAge,
          maxNrOfCacheObjects: 200,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );

  /// Get cache size in bytes
  /// Monitors current cache size for LRU eviction
  Future<int> getCacheSize() async {
    final cacheDir = await _getCacheDirectory();
    if (!await cacheDir.exists()) {
      return 0;
    }

    int totalSize = 0;
    await for (final entity in cacheDir.list(recursive: true)) {
      if (entity is File) {
        try {
          final stat = await entity.stat();
          totalSize += stat.size;
        } catch (e) {
          // Skip files that can't be accessed
          continue;
        }
      }
    }

    return totalSize;
  }

  /// Check if cache size exceeds maximum limit
  Future<bool> exceedsMaxSize() async {
    final currentSize = await getCacheSize();
    return currentSize > AppConstants.maxCacheSizeBytes;
  }

  /// Get cache directory
  Future<Directory> _getCacheDirectory() async {
    final baseDir = await getTemporaryDirectory();
    return Directory('${baseDir.path}/$key');
  }

  /// Get all cached files sorted by last modified time (oldest first)
  /// Used for LRU eviction policy
  Future<List<File>> getCachedFilesSortedByAge() async {
    final cacheDir = await _getCacheDirectory();
    if (!await cacheDir.exists()) {
      return [];
    }

    final files = <File>[];
    await for (final entity in cacheDir.list(recursive: true)) {
      if (entity is File) {
        files.add(entity);
      }
    }

    // Sort by last modified time (oldest first)
    files.sort((a, b) {
      final aStat = a.statSync();
      final bStat = b.statSync();
      return aStat.modified.compareTo(bStat.modified);
    });

    return files;
  }

  /// Evict oldest files until cache size is under limit
  /// Implements LRU eviction policy
  Future<void> evictOldestUntilUnderLimit() async {
    while (await exceedsMaxSize()) {
      final files = await getCachedFilesSortedByAge();
      if (files.isEmpty) {
        break;
      }

      // Remove oldest file
      final oldestFile = files.first;
      try {
        await oldestFile.delete();
      } catch (e) {
        // If deletion fails, break to avoid infinite loop
        break;
      }
    }
  }
}
