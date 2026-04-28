import '../repositories/favorite_repository.dart';

/// Use case for getting favorite wallpaper IDs
/// Requirements: 6.1, 6.2, 6.3, 6.4, 6.5
class GetFavoritesUseCase {
  final FavoriteRepository _repository;

  const GetFavoritesUseCase(this._repository);

  /// Execute the use case to get favorite wallpaper IDs
  ///
  /// Returns list of wallpaper IDs
  Future<List<String>> execute() async {
    return await _repository.getFavoriteIds();
  }

  /// Watch favorites for changes
  ///
  /// Returns stream of favorite wallpaper IDs
  Stream<List<String>> watch() {
    return _repository.watchFavorites();
  }
}
