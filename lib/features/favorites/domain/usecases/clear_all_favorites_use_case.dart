import '../repositories/favorite_repository.dart';

/// Use case for clearing all favorites
/// Requirements: 6.2, 6.5
class ClearAllFavoritesUseCase {
  final FavoriteRepository _repository;

  ClearAllFavoritesUseCase({required FavoriteRepository repository})
    : _repository = repository;

  /// Execute the use case
  ///
  /// Clears all favorite wallpapers
  Future<void> execute() async {
    await _repository.clearAll();
  }
}
