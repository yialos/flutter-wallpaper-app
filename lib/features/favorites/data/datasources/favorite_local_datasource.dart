import 'package:hive_flutter/hive_flutter.dart';
import '../models/favorite_wallpaper_entity.dart';

/// Local data source for favorites using Hive
/// Requirements: 6.2, 6.5
class FavoriteLocalDataSource {
  static const String _boxName = 'favorites';
  Box<FavoriteWallpaperEntity>? _box;

  /// Initialize Hive box
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<FavoriteWallpaperEntity>(_boxName);
    }
  }

  /// Get all favorite wallpaper IDs
  Future<List<String>> getFavoriteIds() async {
    await init();
    return _box!.values.map((e) => e.wallpaperId).toList();
  }

  /// Add wallpaper to favorites
  Future<void> addFavorite(String wallpaperId) async {
    await init();
    final entity = FavoriteWallpaperEntity.fromWallpaperId(wallpaperId);
    await _box!.put(wallpaperId, entity);
  }

  /// Remove wallpaper from favorites
  Future<void> removeFavorite(String wallpaperId) async {
    await init();
    await _box!.delete(wallpaperId);
  }

  /// Check if wallpaper is favorited
  Future<bool> isFavorite(String wallpaperId) async {
    await init();
    return _box!.containsKey(wallpaperId);
  }

  /// Watch favorites for changes
  Stream<List<String>> watchFavorites() async* {
    await init();

    // Emit initial state
    yield _box!.values.map((e) => e.wallpaperId).toList();

    // Watch for changes
    await for (final _ in _box!.watch()) {
      yield _box!.values.map((e) => e.wallpaperId).toList();
    }
  }

  /// Clear all favorites
  Future<void> clearAll() async {
    await init();
    await _box!.clear();
  }
}
