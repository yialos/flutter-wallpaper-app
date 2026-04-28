import '../repositories/favorite_repository.dart';

/// Use case for toggling favorite status of a wallpaper
/// Requirements: 6.1, 6.2, 6.3, 6.4, 6.5
class ToggleFavoriteUseCase {
  final FavoriteRepository _repository;

  const ToggleFavoriteUseCase(this._repository);

  /// Execute the use case to toggle favorite status
  ///
  /// [wallpaperId] - Wallpaper unique identifier
  ///
  /// Returns true if wallpaper is now favorited, false if unfavorited
  Future<bool> execute(String wallpaperId) async {
    final isFavorite = await _repository.isFavorite(wallpaperId);

    if (isFavorite) {
      await _repository.removeFavorite(wallpaperId);
      return false;
    } else {
      await _repository.addFavorite(wallpaperId);
      return true;
    }
  }

  /// Check if a wallpaper is favorited
  ///
  /// [wallpaperId] - Wallpaper unique identifier
  ///
  /// Returns true if favorited, false otherwise
  Future<bool> isFavorite(String wallpaperId) async {
    return await _repository.isFavorite(wallpaperId);
  }
}
