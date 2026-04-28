import '../repositories/collection_repository.dart';

/// Use case for removing wallpaper from collection
class RemoveWallpaperFromCollectionUseCase {
  final CollectionRepository _repository;

  RemoveWallpaperFromCollectionUseCase(this._repository);

  /// Execute remove wallpaper from collection
  Future<void> execute({
    required String collectionId,
    required String wallpaperId,
  }) async {
    await _repository.removeWallpaperFromCollection(collectionId, wallpaperId);
  }
}
