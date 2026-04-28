import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../domain/repositories/cache_repository.dart';
import '../datasources/cache_metadata_local_datasource.dart';
import '../models/cached_wallpaper_metadata.dart';
import '../services/cache_manager.dart';
import '../../../../core/constants/app_constants.dart';

/// Implementation of CacheRepository
/// Requirements: 7.1, 7.2, 7.4, 7.5
class CacheRepositoryImpl implements CacheRepository {
  final CacheMetadataLocalDataSource _metadataDataSource;
  final WallpaperCacheManager _cacheManager;

  const CacheRepositoryImpl({
    required CacheMetadataLocalDataSource metadataDataSource,
    required WallpaperCacheManager cacheManager,
  }) : _metadataDataSource = metadataDataSource,
       _cacheManager = cacheManager;

  @override
  Future<File?> getCachedWallpaper(String wallpaperId) async {
    try {
      // Get metadata to find local path
      final metadata = await _metadataDataSource.getMetadata(wallpaperId);

      if (metadata == null) {
        return null;
      }

      // Check if file exists
      final file = File(metadata.localPath);
      if (!await file.exists()) {
        // Clean up stale metadata
        await _metadataDataSource.deleteMetadata(wallpaperId);
        return null;
      }

      // Update last accessed time for LRU tracking
      await _metadataDataSource.updateLastAccessed(wallpaperId);

      return file;
    } catch (e) {
      // Return null if any error occurs
      return null;
    }
  }

  @override
  Future<void> cacheWallpaper(String wallpaperId, File imageFile) async {
    try {
      // Get cache directory
      final cacheDir = await _getCacheDirectory();
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      // Create unique filename
      final extension = imageFile.path.split('.').last;
      final cachedFilePath = '${cacheDir.path}/$wallpaperId.$extension';

      // Copy file to cache directory
      final cachedFile = await imageFile.copy(cachedFilePath);

      // Get file size
      final fileStat = await cachedFile.stat();
      final fileSize = fileStat.size;

      // Save metadata
      final metadata = CachedWallpaperMetadata(
        wallpaperId: wallpaperId,
        localPath: cachedFilePath,
        fileSizeBytes: fileSize,
        cachedAt: DateTime.now(),
        lastAccessedAt: DateTime.now(),
      );

      await _metadataDataSource.saveMetadata(metadata);

      // Check if cache size exceeds limit and evict if needed
      await evictOldestIfNeeded();
    } catch (e) {
      // Rethrow to let caller handle the error
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      // Clear all cached files
      await _cacheManager.emptyCache();

      // Clear cache directory
      final cacheDir = await _getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }

      // Clear all metadata
      await _metadataDataSource.clearAll();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getCacheSize() async {
    try {
      // Get size from cache manager
      final cacheManagerSize = await _cacheManager.getCacheSize();

      // Get size from our custom cache directory
      final cacheDir = await _getCacheDirectory();
      int customCacheSize = 0;

      if (await cacheDir.exists()) {
        await for (final entity in cacheDir.list(recursive: true)) {
          if (entity is File) {
            try {
              final stat = await entity.stat();
              customCacheSize += stat.size;
            } catch (e) {
              continue;
            }
          }
        }
      }

      return cacheManagerSize + customCacheSize;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> evictOldestIfNeeded() async {
    try {
      final currentSize = await getCacheSize();

      // Check if cache size exceeds limit (500 MB)
      if (currentSize <= AppConstants.maxCacheSizeBytes) {
        return;
      }

      // Get all metadata sorted by last accessed time (LRU)
      final allMetadata = await _metadataDataSource.getAllMetadata();

      // Sort by lastAccessedAt (oldest first)
      allMetadata.sort((a, b) => a.lastAccessedAt.compareTo(b.lastAccessedAt));

      // Evict oldest items until under limit
      int freedSpace = 0;
      final targetFreeSpace = currentSize - AppConstants.maxCacheSizeBytes;

      for (final metadata in allMetadata) {
        if (freedSpace >= targetFreeSpace) {
          break;
        }

        try {
          // Delete file
          final file = File(metadata.localPath);
          if (await file.exists()) {
            await file.delete();
            freedSpace += metadata.fileSizeBytes;
          }

          // Delete metadata
          await _metadataDataSource.deleteMetadata(metadata.wallpaperId);
        } catch (e) {
          // Continue with next file if deletion fails
          continue;
        }
      }

      // Also evict from cache manager
      await _cacheManager.evictOldestUntilUnderLimit();
    } catch (e) {
      // Log error but don't throw to avoid breaking the app
      return;
    }
  }

  /// Get cache directory for wallpapers
  Future<Directory> _getCacheDirectory() async {
    final tempDir = await getTemporaryDirectory();
    return Directory('${tempDir.path}/wallpaper_cache');
  }
}
