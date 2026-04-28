import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/cache_repository.dart';
import '../repositories/cache_repository_impl.dart';
import '../datasources/cache_metadata_local_datasource.dart';
import '../services/cache_manager.dart';

/// Provider for CacheMetadataLocalDataSource
final cacheMetadataLocalDataSourceProvider =
    Provider<CacheMetadataLocalDataSource>((ref) {
      throw UnimplementedError(
        'CacheMetadataLocalDataSource must be initialized in main.dart',
      );
    });

/// Provider for WallpaperCacheManager
final wallpaperCacheManagerProvider = Provider<WallpaperCacheManager>((ref) {
  return WallpaperCacheManager();
});

/// Provider for CacheRepository
final cacheRepositoryProvider = Provider<CacheRepository>((ref) {
  return CacheRepositoryImpl(
    metadataDataSource: ref.watch(cacheMetadataLocalDataSourceProvider),
    cacheManager: ref.watch(wallpaperCacheManagerProvider),
  );
});
