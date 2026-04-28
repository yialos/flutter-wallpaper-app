import 'package:hive/hive.dart';

part 'favorite_wallpaper_entity.g.dart';

/// Hive entity for storing favorite wallpapers
/// Requirements: 6.5
@HiveType(typeId: 0)
class FavoriteWallpaperEntity extends HiveObject {
  @HiveField(0)
  final String wallpaperId;

  @HiveField(1)
  final DateTime addedAt;

  FavoriteWallpaperEntity({required this.wallpaperId, required this.addedAt});

  /// Create from wallpaper ID
  factory FavoriteWallpaperEntity.fromWallpaperId(String wallpaperId) {
    return FavoriteWallpaperEntity(
      wallpaperId: wallpaperId,
      addedAt: DateTime.now(),
    );
  }
}
