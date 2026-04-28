import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for browsing wallpapers with pagination
/// Requirements: 1.1, 1.2, 1.3, 1.4
class BrowseWallpapersUseCase {
  final WallpaperRepository _repository;

  const BrowseWallpapersUseCase(this._repository);

  /// Execute the use case to get paginated wallpapers
  ///
  /// [page] - Page number (1-indexed)
  /// [pageSize] - Number of items per page (default: 20)
  /// [category] - Optional category filter
  ///
  /// Returns paginated result with wallpapers
  Future<PaginatedResult<Wallpaper>> execute({
    required int page,
    int pageSize = 20,
    String? category,
  }) async {
    return await _repository.getWallpapers(
      page: page,
      pageSize: pageSize,
      category: category,
    );
  }
}
