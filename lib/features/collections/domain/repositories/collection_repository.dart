import '../entities/collection.dart';

/// Repository interface for collection operations
abstract class CollectionRepository {
  /// Get all collections
  Future<List<Collection>> getAllCollections();

  /// Get collection by ID
  Future<Collection?> getCollectionById(String id);

  /// Create new collection
  Future<void> createCollection(Collection collection);

  /// Update collection
  Future<void> updateCollection(Collection collection);

  /// Delete collection
  Future<void> deleteCollection(String id);

  /// Add wallpaper to collection
  Future<void> addWallpaperToCollection(
    String collectionId,
    String wallpaperId,
  );

  /// Remove wallpaper from collection
  Future<void> removeWallpaperFromCollection(
    String collectionId,
    String wallpaperId,
  );

  /// Check if wallpaper is in collection
  Future<bool> isWallpaperInCollection(String collectionId, String wallpaperId);

  /// Get collections containing wallpaper
  Future<List<Collection>> getCollectionsContainingWallpaper(
    String wallpaperId,
  );

  /// Watch collections for changes
  Stream<List<Collection>> watchCollections();

  /// Clear all collections
  Future<void> clearAll();
}
