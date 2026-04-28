import '../entities/entities.dart';

/// Repository interface for category operations
/// Requirements: 3.1, 3.2
abstract class CategoryRepository {
  /// Get all available categories
  ///
  /// Returns list of categories
  Future<List<Category>> getCategories();

  /// Get wallpapers by category
  ///
  /// [categoryId] - Category unique identifier
  /// [page] - Page number (1-indexed)
  /// [pageSize] - Number of items per page
  ///
  /// Returns paginated result with wallpapers
  Future<PaginatedResult<Wallpaper>> getWallpapersByCategory(
    String categoryId, {
    required int page,
    required int pageSize,
  });
}
