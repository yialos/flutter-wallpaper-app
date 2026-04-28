import '../repositories/collection_repository.dart';

/// Use case for adding wallpaper to collection
class AddWallpaperToCollectionUseCase {
  final CollectionRepository _repository;

  AddWallpaperToCollectionUseCase(this._repository);

  /// Execute add wallpaper to collection
  Future<void> execute({
    required String collectionId,
    required String wallpaperId,
  }) async {
    // Check if already in collection
    final isInCollection = await _repository.isWallpaperInCollection(
      collectionId,
      wallpaperId,
    );

    if (isInCollection) {
      throw ArgumentError('Hình nền đã có trong collection này');
    }

    await _repository.addWallpaperToCollection(collectionId, wallpaperId);
  }
}
