import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/features/favorites/domain/usecases/get_favorites_use_case.dart';
import 'package:wallpaper_app/features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'package:wallpaper_app/features/favorites/domain/usecases/clear_all_favorites_use_case.dart';
import 'package:wallpaper_app/features/favorites/domain/providers/favorite_domain_providers.dart';

/// State class for favorites with reactive updates
/// Requirements: 6.2, 6.3, 6.4
class FavoriteState {
  final Set<String> favoriteIds;
  final bool isLoading;
  final String? error;

  const FavoriteState({
    this.favoriteIds = const {},
    this.isLoading = false,
    this.error,
  });

  FavoriteState copyWith({
    Set<String>? favoriteIds,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return FavoriteState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  /// Check if a wallpaper is favorited
  bool isFavorite(String wallpaperId) {
    return favoriteIds.contains(wallpaperId);
  }

  /// Get count of favorites
  int get count => favoriteIds.length;
}

/// State notifier for favorite management with reactive updates
/// Requirements: 6.1, 6.2, 6.3, 6.4, 6.5
class FavoriteNotifier extends StateNotifier<FavoriteState> {
  final GetFavoritesUseCase _getFavoritesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final ClearAllFavoritesUseCase _clearAllFavoritesUseCase;

  FavoriteNotifier(
    this._getFavoritesUseCase,
    this._toggleFavoriteUseCase,
    this._clearAllFavoritesUseCase,
  ) : super(const FavoriteState());

  /// Load favorite IDs
  /// Requirements: 6.2, 6.4
  Future<void> loadFavorites() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final favoriteIds = await _getFavoritesUseCase.execute();

      state = state.copyWith(
        favoriteIds: Set<String>.from(favoriteIds),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Toggle favorite status for a wallpaper
  /// Requirements: 6.1, 6.2, 6.3
  Future<void> toggleFavorite(String wallpaperId) async {
    final wasFavorite = state.isFavorite(wallpaperId);

    // Optimistically update UI
    final updatedFavorites = Set<String>.from(state.favoriteIds);
    if (wasFavorite) {
      updatedFavorites.remove(wallpaperId);
    } else {
      updatedFavorites.add(wallpaperId);
    }

    state = state.copyWith(favoriteIds: updatedFavorites, clearError: true);

    try {
      await _toggleFavoriteUseCase.execute(wallpaperId);
    } catch (e) {
      // Revert on error
      final revertedFavorites = Set<String>.from(state.favoriteIds);
      if (wasFavorite) {
        revertedFavorites.add(wallpaperId);
      } else {
        revertedFavorites.remove(wallpaperId);
      }

      state = state.copyWith(
        favoriteIds: revertedFavorites,
        error: e.toString(),
      );
    }
  }

  /// Add a wallpaper to favorites
  /// Requirements: 6.2, 6.3
  Future<void> addFavorite(String wallpaperId) async {
    if (state.isFavorite(wallpaperId)) return;
    await toggleFavorite(wallpaperId);
  }

  /// Remove a wallpaper from favorites
  /// Requirements: 6.2, 6.3
  Future<void> removeFavorite(String wallpaperId) async {
    if (!state.isFavorite(wallpaperId)) return;
    await toggleFavorite(wallpaperId);
  }

  /// Clear any error state
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear all favorites
  /// Requirements: 6.2, 6.5
  Future<void> clearAll() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _clearAllFavoritesUseCase.execute();
      state = state.copyWith(favoriteIds: {}, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Provider for FavoriteNotifier
/// Requirements: 6.1, 6.2, 6.3, 6.4, 6.5
final favoriteNotifierProvider =
    StateNotifierProvider<FavoriteNotifier, FavoriteState>((ref) {
      final getFavoritesUseCase = ref.watch(getFavoritesUseCaseProvider);
      final toggleFavoriteUseCase = ref.watch(toggleFavoriteUseCaseProvider);
      final clearAllFavoritesUseCase = ref.watch(
        clearAllFavoritesUseCaseProvider,
      );
      return FavoriteNotifier(
        getFavoritesUseCase,
        toggleFavoriteUseCase,
        clearAllFavoritesUseCase,
      );
    });
