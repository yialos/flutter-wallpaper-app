import '../../../browse/domain/entities/entities.dart';

/// Repository interface for search operations
/// Requirements: 2.1, 2.2
abstract class SearchRepository {
  /// Search wallpapers by query
  ///
  /// [query] - Search query string
  /// [limit] - Optional limit for results
  ///
  /// Returns list of matching wallpapers
  Future<List<Wallpaper>> searchWallpapers({required String query, int? limit});
}
