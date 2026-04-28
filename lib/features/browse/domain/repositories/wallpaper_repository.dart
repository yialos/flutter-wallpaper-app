import '../entities/entities.dart';

/// Repository interface for wallpaper operations
/// Requirements: 1.1, 2.1, 3.1, 4.1, 6.1, 7.1
abstract class WallpaperRepository {
  /// Get paginated wallpapers
  ///
  /// [page] - Page number (1-indexed)
  /// [pageSize] - Number of items per page
  /// [category] - Optional category filter
  ///
  /// Returns paginated result with wallpapers
  Future<PaginatedResult<Wallpaper>> getWallpapers({
    required int page,
    required int pageSize,
    String? category,
  });

  /// Get wallpaper by ID
  ///
  /// [id] - Wallpaper unique identifier
  ///
  /// Returns wallpaper entity
  Future<Wallpaper> getWallpaperById(String id);
}
