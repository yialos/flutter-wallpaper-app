/// Repository interface for favorite operations
/// Requirements: 6.1, 6.2, 6.3, 6.4, 6.5
abstract class FavoriteRepository {
  /// Get list of favorite wallpaper IDs
  ///
  /// Returns list of wallpaper IDs
  Future<List<String>> getFavoriteIds();

  /// Add wallpaper to favorites
  ///
  /// [wallpaperId] - Wallpaper unique identifier
  Future<void> addFavorite(String wallpaperId);

  /// Remove wallpaper from favorites
  ///
  /// [wallpaperId] - Wallpaper unique identifier
  Future<void> removeFavorite(String wallpaperId);

  /// Check if wallpaper is favorited
  ///
  /// [wallpaperId] - Wallpaper unique identifier
  ///
  /// Returns true if favorited, false otherwise
  Future<bool> isFavorite(String wallpaperId);

  /// Watch favorites for changes
  ///
  /// Returns stream of favorite wallpaper IDs
  Stream<List<String>> watchFavorites();

  /// Clear all favorites
  ///
  /// Removes all wallpapers from favorites
  Future<void> clearAll();
}
