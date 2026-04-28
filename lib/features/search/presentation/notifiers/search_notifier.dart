import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/features/search/domain/usecases/search_wallpapers_use_case.dart';
import 'package:wallpaper_app/features/search/presentation/providers/search_providers.dart';
import 'search_state.dart';

/// State notifier for search with debouncing
/// Requirements: 2.1, 2.2, 2.3, 2.4, 2.5
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchWallpapersUseCase _searchWallpapersUseCase;

  SearchNotifier(this._searchWallpapersUseCase) : super(const SearchState());

  /// Search wallpapers by query with debouncing
  /// Requirements: 2.1, 2.2, 2.4
  Future<void> searchWallpapers(String query) async {
    // Update query immediately for UI feedback
    state = state.copyWith(query: query, clearError: true);

    // Clear results if query is empty
    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    // Set searching state
    state = state.copyWith(isSearching: true);

    try {
      // Use the debounced execute method with callback
      _searchWallpapersUseCase.execute(
        query: query,
        onResult: (resultFuture) async {
          try {
            final results = await resultFuture;

            // Only update if query hasn't changed
            if (state.query == query) {
              state = state.copyWith(
                results: results,
                isSearching: false,
                hasSearched: true,
              );
            }
          } catch (e) {
            // Only update error if query hasn't changed
            if (state.query == query) {
              state = state.copyWith(
                isSearching: false,
                error: e.toString(),
                hasSearched: true,
              );
            }
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: e.toString(),
        hasSearched: true,
      );
    }
  }

  /// Clear search results and query
  /// Requirements: 2.5
  void clearSearch() {
    state = const SearchState();
  }

  /// Clear any error state
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for SearchNotifier
/// Requirements: 2.1, 2.2, 2.3, 2.4, 2.5
final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
      final searchWallpapersUseCase = ref.watch(
        searchWallpapersUseCaseProvider,
      );
      return SearchNotifier(searchWallpapersUseCase);
    });
