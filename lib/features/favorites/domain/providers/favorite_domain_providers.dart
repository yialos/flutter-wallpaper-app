import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/favorite_data_providers.dart';
import '../usecases/get_favorites_use_case.dart';
import '../usecases/toggle_favorite_use_case.dart';
import '../usecases/clear_all_favorites_use_case.dart';

/// Provider for GetFavoritesUseCase
/// Requirements: 6.1, 6.2, 6.4
final getFavoritesUseCaseProvider = Provider<GetFavoritesUseCase>((ref) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return GetFavoritesUseCase(repository);
});

/// Provider for ToggleFavoriteUseCase
/// Requirements: 6.1, 6.2, 6.3
final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUseCase>((ref) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return ToggleFavoriteUseCase(repository);
});

/// Provider for ClearAllFavoritesUseCase
/// Requirements: 6.2, 6.5
final clearAllFavoritesUseCaseProvider = Provider<ClearAllFavoritesUseCase>((
  ref,
) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return ClearAllFavoritesUseCase(repository: repository);
});
