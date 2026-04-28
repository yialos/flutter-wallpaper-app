import '../../domain/entities/collection.dart';
import '../../domain/repositories/collection_repository.dart';
import '../datasources/collection_local_datasource.dart';
import '../models/collection_entity.dart';

/// Implementation of CollectionRepository
class CollectionRepositoryImpl implements CollectionRepository {
  final CollectionLocalDataSource _localDataSource;

  CollectionRepositoryImpl({required CollectionLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<List<Collection>> getAllCollections() async {
    final entities = await _localDataSource.getAllCollections();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Collection?> getCollectionById(String id) async {
    final entity = await _localDataSource.getCollectionById(id);
    return entity?.toDomain();
  }

  @override
  Future<void> createCollection(Collection collection) async {
    final entity = await _localDataSource.getCollectionById(collection.id);
    if (entity != null) {
      throw CollectionException('Collection với ID này đã tồn tại');
    }
    await _localDataSource.createCollection(
      CollectionEntity.fromDomain(collection),
    );
  }

  @override
  Future<void> updateCollection(Collection collection) async {
    await _localDataSource.updateCollection(
      CollectionEntity.fromDomain(collection),
    );
  }

  @override
  Future<void> deleteCollection(String id) async {
    await _localDataSource.deleteCollection(id);
  }

  @override
  Future<void> addWallpaperToCollection(
    String collectionId,
    String wallpaperId,
  ) async {
    await _localDataSource.addWallpaperToCollection(collectionId, wallpaperId);
  }

  @override
  Future<void> removeWallpaperFromCollection(
    String collectionId,
    String wallpaperId,
  ) async {
    await _localDataSource.removeWallpaperFromCollection(
      collectionId,
      wallpaperId,
    );
  }

  @override
  Future<bool> isWallpaperInCollection(
    String collectionId,
    String wallpaperId,
  ) async {
    return await _localDataSource.isWallpaperInCollection(
      collectionId,
      wallpaperId,
    );
  }

  @override
  Future<List<Collection>> getCollectionsContainingWallpaper(
    String wallpaperId,
  ) async {
    final entities = await _localDataSource.getCollectionsContainingWallpaper(
      wallpaperId,
    );
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Stream<List<Collection>> watchCollections() {
    return _localDataSource.watchCollections().map(
      (entities) => entities.map((e) => e.toDomain()).toList(),
    );
  }

  @override
  Future<void> clearAll() async {
    await _localDataSource.clearAll();
  }
}

/// Exception thrown when collection operation fails
class CollectionException implements Exception {
  final String message;

  CollectionException(this.message);

  @override
  String toString() => message;
}
