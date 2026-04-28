import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/features/favorites/data/providers/favorite_providers.dart';

/// Stream provider for favorites with reactive updates
/// Requirements: 6.4
final favoritesStreamProvider = StreamProvider<List<String>>((ref) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return repository.watchFavorites();
});

/// Provider to check if a specific wallpaper is favorited (reactive)
/// Requirements: 6.4
final isFavoriteProvider = Provider.family<bool, String>((ref, wallpaperId) {
  final favoritesAsync = ref.watch(favoritesStreamProvider);
  return favoritesAsync.when(
    data: (favorites) => favorites.contains(wallpaperId),
    loading: () => false,
    error: (_, _) => false,
  );
});

/// Provider for favorite count (reactive)
/// Requirements: 6.4
final favoriteCountProvider = Provider<int>((ref) {
  final favoritesAsync = ref.watch(favoritesStreamProvider);
  return favoritesAsync.when(
    data: (favorites) => favorites.length,
    loading: () => 0,
    error: (_, _) => 0,
  );
});
