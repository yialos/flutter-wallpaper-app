import '../entities/collection.dart';
import '../repositories/collection_repository.dart';

/// Use case for getting collections containing a specific wallpaper
class GetCollectionsContainingWallpaperUseCase {
  final CollectionRepository _repository;

  GetCollectionsContainingWallpaperUseCase(this._repository);

  /// Execute get collections containing wallpaper
  Future<List<Collection>> execute(String wallpaperId) async {
    return await _repository.getCollectionsContainingWallpaper(wallpaperId);
  }
}
