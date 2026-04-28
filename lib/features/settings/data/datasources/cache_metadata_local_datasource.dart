import 'package:hive/hive.dart';
import '../models/cached_wallpaper_metadata.dart';

/// Local data source for cache metadata operations using Hive
/// Requirements: 6.2, 6.5, 7.1
abstract class CacheMetadataLocalDataSource {
  /// Get cache metadata for a wallpaper
  Future<CachedWallpaperMetadata?> getMetadata(String wallpaperId);

  /// Save cache metadata
  Future<void> saveMetadata(CachedWallpaperMetadata metadata);

  /// Delete cache metadata
  Future<void> deleteMetadata(String wallpaperId);

  /// Get all cache metadata
  Future<List<CachedWallpaperMetadata>> getAllMetadata();

  /// Update last accessed time
  Future<void> updateLastAccessed(String wallpaperId);

  /// Clear all cache metadata
  Future<void> clearAll();

  /// Get total cache size in bytes
  Future<int> getTotalCacheSize();
}

/// Implementation of CacheMetadataLocalDataSource using Hive
class CacheMetadataLocalDataSourceImpl implements CacheMetadataLocalDataSource {
  static const String _boxName = 'cache_metadata';
  final Box<CachedWallpaperMetadata> _box;

  const CacheMetadataLocalDataSourceImpl(this._box);

  /// Get Hive box for cache metadata
  static Future<Box<CachedWallpaperMetadata>> getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<CachedWallpaperMetadata>(_boxName);
    }
    return Hive.box<CachedWallpaperMetadata>(_boxName);
  }

  @override
  Future<CachedWallpaperMetadata?> getMetadata(String wallpaperId) async {
    return _box.get(wallpaperId);
  }

  @override
  Future<void> saveMetadata(CachedWallpaperMetadata metadata) async {
    await _box.put(metadata.wallpaperId, metadata);
  }

  @override
  Future<void> deleteMetadata(String wallpaperId) async {
    await _box.delete(wallpaperId);
  }

  @override
  Future<List<CachedWallpaperMetadata>> getAllMetadata() async {
    return _box.values.toList();
  }

  @override
  Future<void> updateLastAccessed(String wallpaperId) async {
    final metadata = await getMetadata(wallpaperId);
    if (metadata != null) {
      final updated = metadata.copyWith(lastAccessedAt: DateTime.now());
      await saveMetadata(updated);
    }
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }

  @override
  Future<int> getTotalCacheSize() async {
    int totalSize = 0;
    for (final metadata in _box.values) {
      totalSize += metadata.fileSizeBytes;
    }
    return totalSize;
  }
}
