import 'package:wallpaper_app/features/browse/domain/entities/entities.dart';

/// State class for search
/// Requirements: 2.1, 2.2
class SearchState {
  final List<Wallpaper> results;
  final String query;
  final bool isSearching;
  final String? error;
  final bool hasSearched;

  const SearchState({
    this.results = const [],
    this.query = '',
    this.isSearching = false,
    this.error,
    this.hasSearched = false,
  });

  SearchState copyWith({
    List<Wallpaper>? results,
    String? query,
    bool? isSearching,
    String? error,
    bool? hasSearched,
    bool clearError = false,
  }) {
    return SearchState(
      results: results ?? this.results,
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      error: clearError ? null : (error ?? this.error),
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }

  bool get isEmpty => hasSearched && results.isEmpty && error == null;

  /// Helper method for pattern matching
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(List<Wallpaper> wallpapers) loaded,
    required T Function(String message) error,
  }) {
    if (this.error != null) {
      return error(this.error!);
    }
    if (isSearching) {
      return loading();
    }
    if (hasSearched) {
      return loaded(results);
    }
    return initial();
  }
}
