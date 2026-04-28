import 'package:hive/hive.dart';

part 'cached_wallpaper_metadata.g.dart';

/// Local storage entity for cached wallpaper metadata using Hive
@HiveType(typeId: 1)
class CachedWallpaperMetadata extends HiveObject {
  @HiveField(0)
  final String wallpaperId;

  @HiveField(1)
  final String localPath;

  @HiveField(2)
  final int fileSizeBytes;

  @HiveField(3)
  final DateTime cachedAt;

  @HiveField(4)
  final DateTime lastAccessedAt;

  CachedWallpaperMetadata({
    required this.wallpaperId,
    required this.localPath,
    required this.fileSizeBytes,
    required this.cachedAt,
    required this.lastAccessedAt,
  });

  /// Create a copy with updated lastAccessedAt
  CachedWallpaperMetadata copyWith({
    String? wallpaperId,
    String? localPath,
    int? fileSizeBytes,
    DateTime? cachedAt,
    DateTime? lastAccessedAt,
  }) {
    return CachedWallpaperMetadata(
      wallpaperId: wallpaperId ?? this.wallpaperId,
      localPath: localPath ?? this.localPath,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      cachedAt: cachedAt ?? this.cachedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    );
  }

  @override
  String toString() =>
      'CachedWallpaperMetadata(wallpaperId: $wallpaperId, localPath: $localPath, fileSizeBytes: $fileSizeBytes, cachedAt: $cachedAt, lastAccessedAt: $lastAccessedAt)';
}
