# Cache Manager Implementation

## Overview

This directory contains the implementation of the Cache Manager for the Wallpaper App, fulfilling Task 7 requirements.

## Components

### 1. CacheManager (services/cache_manager.dart)

Custom cache manager built on top of `flutter_cache_manager` that provides:

- **Cache Size Monitoring**: Tracks total cache size in bytes
- **LRU Eviction Policy**: Automatically removes oldest cached items when cache exceeds 500 MB limit
- **Max Cache Size**: Configured to 500 MB (from AppConstants)
- **Cache Age Management**: Respects 30-day cache age limit

**Key Methods:**
- `getCacheSize()`: Returns current cache size in bytes
- `exceedsMaxSize()`: Checks if cache exceeds 500 MB limit
- `getCachedFilesSortedByAge()`: Returns files sorted by age (oldest first) for LRU eviction
- `evictOldestUntilUnderLimit()`: Removes oldest files until cache is under limit

**Requirements Fulfilled:** 7.1, 7.3, 7.4

### 2. CacheRepositoryImpl (repositories/cache_repository_impl.dart)

Implementation of the `CacheRepository` interface that provides:

- **getCachedWallpaper**: Retrieves cached wallpaper by ID, updates last accessed time for LRU tracking
- **cacheWallpaper**: Stores wallpaper in cache with metadata, triggers eviction if needed
- **clearCache**: Removes all cached wallpapers and metadata
- **getCacheSize**: Returns total cache size from both cache manager and custom cache directory
- **evictOldestIfNeeded**: Implements LRU eviction when cache exceeds 500 MB

**LRU Eviction Strategy:**
1. Gets all cached wallpaper metadata
2. Sorts by `lastAccessedAt` (oldest first)
3. Deletes oldest files until cache size is under 500 MB limit
4. Updates metadata to reflect deletions

**Requirements Fulfilled:** 7.1, 7.2, 7.4, 7.5

### 3. Providers (providers/cache_providers.dart)

Riverpod providers for dependency injection:

- `cacheMetadataLocalDataSourceProvider`: Provides access to Hive-based metadata storage
- `wallpaperCacheManagerProvider`: Provides singleton instance of WallpaperCacheManager
- `cacheRepositoryProvider`: Provides CacheRepository implementation

## Integration

### main.dart

The cache system is initialized in `main.dart`:

```dart
// Open Hive box for cache metadata
final cacheMetadataBox = await Hive.openBox<CachedWallpaperMetadata>(
  AppConstants.cacheMetadataBoxName
);

// Initialize cache metadata data source
final cacheMetadataDataSource = CacheMetadataLocalDataSourceImpl(cacheMetadataBox);

// Provide to app via ProviderScope
ProviderScope(
  overrides: [
    cacheMetadataLocalDataSourceProvider.overrideWithValue(cacheMetadataDataSource),
  ],
  child: const WallpaperApp(),
)
```

## Usage Example

```dart
// Get cache repository
final cacheRepo = ref.read(cacheRepositoryProvider);

// Cache a wallpaper
await cacheRepo.cacheWallpaper('wallpaper_123', imageFile);

// Retrieve cached wallpaper
final cachedFile = await cacheRepo.getCachedWallpaper('wallpaper_123');

// Get cache size
final size = await cacheRepo.getCacheSize();
print('Cache size: ${size / (1024 * 1024)} MB');

// Clear all cache
await cacheRepo.clearCache();

// Manual eviction (automatic eviction happens on cache)
await cacheRepo.evictOldestIfNeeded();
```

## Cache Configuration

From `AppConstants`:
- **Max Cache Size**: 500 MB (500 * 1024 * 1024 bytes)
- **Max Cache Age**: 30 days
- **Max Cache Objects**: 200 items

## LRU Eviction Details

The Least Recently Used (LRU) eviction policy works as follows:

1. **Tracking**: Every time a wallpaper is accessed via `getCachedWallpaper()`, the `lastAccessedAt` timestamp is updated
2. **Trigger**: Eviction is triggered when cache size exceeds 500 MB
3. **Selection**: Wallpapers are sorted by `lastAccessedAt` (oldest first)
4. **Eviction**: Oldest wallpapers are deleted one by one until cache size is under limit
5. **Cleanup**: Both the cached file and its metadata are removed

## Requirements Mapping

- **Requirement 7.1**: Cache downloaded wallpapers ✓
  - Implemented in `cacheWallpaper()` method
  
- **Requirement 7.2**: Load from cache when available ✓
  - Implemented in `getCachedWallpaper()` method
  
- **Requirement 7.3**: Limit cache size to configurable maximum ✓
  - Max size set to 500 MB in AppConstants
  - Enforced in `evictOldestIfNeeded()` method
  
- **Requirement 7.4**: Remove oldest cached wallpapers when limit exceeded ✓
  - LRU eviction policy in `evictOldestIfNeeded()` method
  - Automatic eviction after each cache operation
  
- **Requirement 7.5**: Provide setting to clear all cached wallpapers ✓
  - Implemented in `clearCache()` method

## Testing

To test the cache manager:

1. **Unit Tests**: Test individual methods with mocked dependencies
2. **Integration Tests**: Test cache operations with real file system
3. **Performance Tests**: Verify eviction performance with large cache sizes

Example test scenarios:
- Cache a wallpaper and retrieve it
- Cache multiple wallpapers and verify LRU eviction
- Clear cache and verify all files are removed
- Test cache size calculation accuracy
- Test eviction when cache exceeds 500 MB

## Notes

- The cache manager uses both `flutter_cache_manager` for network image caching and a custom cache directory for downloaded wallpapers
- Metadata is stored in Hive for fast access and persistence
- File operations are wrapped in try-catch blocks to handle errors gracefully
- The implementation is thread-safe through async/await patterns
