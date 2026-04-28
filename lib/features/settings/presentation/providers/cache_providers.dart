import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallpaper_app/features/settings/data/datasources/cache_metadata_local_datasource.dart';
import 'package:wallpaper_app/features/settings/data/models/cached_wallpaper_metadata.dart';
import 'package:wallpaper_app/features/settings/data/repositories/cache_repository_impl.dart';
import 'package:wallpaper_app/features/settings/data/services/cache_manager.dart';
import 'package:wallpaper_app/features/settings/domain/repositories/cache_repository.dart';

/// Cache Metadata Local Data Source Provider
/// Requirements: 7.1, 7.2
final cacheMetadataLocalDataSourceProvider =
    Provider<CacheMetadataLocalDataSource>((ref) {
      final box = Hive.box<CachedWallpaperMetadata>('cache_metadata');
      return CacheMetadataLocalDataSourceImpl(box);
    });

/// Wallpaper Cache Manager Provider
/// Requirements: 7.1, 7.3, 7.4
final wallpaperCacheManagerProvider = Provider<WallpaperCacheManager>((ref) {
  return WallpaperCacheManager();
});

/// Cache Repository Provider (singleton)
/// Requirements: 7.1, 7.2, 7.4, 7.5
final cacheRepositoryProvider = Provider<CacheRepository>((ref) {
  final metadataDataSource = ref.watch(cacheMetadataLocalDataSourceProvider);
  final cacheManager = ref.watch(wallpaperCacheManagerProvider);

  return CacheRepositoryImpl(
    metadataDataSource: metadataDataSource,
    cacheManager: cacheManager,
  );
});
