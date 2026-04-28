import '../../../browse/domain/entities/entities.dart';
import '../repositories/search_repository.dart';
import '../utils/search_query_debouncer.dart';

/// Use case for searching wallpapers with debouncing
/// Requirements: 2.1, 2.2, 2.3, 2.4, 2.5
class SearchWallpapersUseCase {
  final SearchRepository _repository;
  final SearchQueryDebouncer _debouncer;

  SearchWallpapersUseCase(this._repository, {SearchQueryDebouncer? debouncer})
    : _debouncer = debouncer ?? SearchQueryDebouncer();

  /// Execute the use case to search wallpapers
  ///
  /// [query] - Search query string
  /// [limit] - Optional limit for results
  /// [onResult] - Callback to receive search results
  ///
  /// This method debounces the search to avoid excessive API calls
  void execute({
    required String query,
    int? limit,
    required void Function(Future<List<Wallpaper>>) onResult,
  }) {
    _debouncer.debounce(() {
      final resultFuture = _repository.searchWallpapers(
        query: query,
        limit: limit,
      );
      onResult(resultFuture);
    });
  }

  /// Execute immediate search without debouncing
  ///
  /// [query] - Search query string
  /// [limit] - Optional limit for results
  ///
  /// Returns list of matching wallpapers
  Future<List<Wallpaper>> executeImmediate({
    required String query,
    int? limit,
  }) async {
    return await _repository.searchWallpapers(query: query, limit: limit);
  }

  /// Cancel any pending debounced searches
  void cancel() {
    _debouncer.cancel();
  }

  /// Dispose of the use case
  void dispose() {
    _debouncer.dispose();
  }
}
