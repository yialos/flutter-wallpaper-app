import 'package:hive_flutter/hive_flutter.dart';
import '../models/collection_entity.dart';

/// Local data source for collections using Hive
class CollectionLocalDataSource {
  static const String _boxName = 'collections';
  Box<CollectionEntity>? _box;

  /// Initialize Hive box
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<CollectionEntity>(_boxName);
    }
  }

  /// Get all collections
  Future<List<CollectionEntity>> getAllCollections() async {
    await init();
    return _box!.values.toList();
  }

  /// Get collection by ID
  Future<CollectionEntity?> getCollectionById(String id) async {
    await init();
    return _box!.get(id);
  }

  /// Create new collection
  Future<void> createCollection(CollectionEntity collection) async {
    await init();
    await _box!.put(collection.id, collection);
  }

  /// Update collection
  Future<void> updateCollection(CollectionEntity collection) async {
    await init();
    await _box!.put(collection.id, collection);
  }

  /// Delete collection
  Future<void> deleteCollection(String id) async {
    await init();
    await _box!.delete(id);
  }

  /// Add wallpaper to collection
  Future<void> addWallpaperToCollection(
    String collectionId,
    String wallpaperId,
  ) async {
    await init();
    final collection = _box!.get(collectionId);
    if (collection != null) {
      final updatedWallpaperIds = List<String>.from(collection.wallpaperIds);
      if (!updatedWallpaperIds.contains(wallpaperId)) {
        updatedWallpaperIds.add(wallpaperId);
        final updatedCollection = CollectionEntity(
          id: collection.id,
          name: collection.name,
          description: collection.description,
          wallpaperIds: updatedWallpaperIds,
          createdAt: collection.createdAt,
          updatedAt: DateTime.now(),
          coverImageUrl: collection.coverImageUrl,
        );
        await _box!.put(collectionId, updatedCollection);
      }
    }
  }

  /// Remove wallpaper from collection
  Future<void> removeWallpaperFromCollection(
    String collectionId,
    String wallpaperId,
  ) async {
    await init();
    final collection = _box!.get(collectionId);
    if (collection != null) {
      final updatedWallpaperIds = List<String>.from(collection.wallpaperIds);
      updatedWallpaperIds.remove(wallpaperId);
      final updatedCollection = CollectionEntity(
        id: collection.id,
        name: collection.name,
        description: collection.description,
        wallpaperIds: updatedWallpaperIds,
        createdAt: collection.createdAt,
        updatedAt: DateTime.now(),
        coverImageUrl: collection.coverImageUrl,
      );
      await _box!.put(collectionId, updatedCollection);
    }
  }

  /// Check if wallpaper is in collection
  Future<bool> isWallpaperInCollection(
    String collectionId,
    String wallpaperId,
  ) async {
    await init();
    final collection = _box!.get(collectionId);
    return collection?.wallpaperIds.contains(wallpaperId) ?? false;
  }

  /// Get collections containing wallpaper
  Future<List<CollectionEntity>> getCollectionsContainingWallpaper(
    String wallpaperId,
  ) async {
    await init();
    return _box!.values
        .where((collection) => collection.wallpaperIds.contains(wallpaperId))
        .toList();
  }

  /// Watch collections for changes
  Stream<List<CollectionEntity>> watchCollections() async* {
    await init();

    // Emit initial state
    yield _box!.values.toList();

    // Watch for changes
    await for (final _ in _box!.watch()) {
      yield _box!.values.toList();
    }
  }

  /// Clear all collections
  Future<void> clearAll() async {
    await init();
    await _box!.clear();
  }
}
