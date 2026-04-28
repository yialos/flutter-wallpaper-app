import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for filtering wallpapers by category
/// Requirements: 3.1, 3.2, 3.3, 3.4
class FilterByCategoryUseCase {
  final CategoryRepository _repository;

  const FilterByCategoryUseCase(this._repository);

  /// Execute the use case to get wallpapers by category
  ///
  /// [categoryId] - Category unique identifier
  /// [page] - Page number (1-indexed)
  /// [pageSize] - Number of items per page (default: 20)
  ///
  /// Returns paginated result with wallpapers
  Future<PaginatedResult<Wallpaper>> execute({
    required String categoryId,
    required int page,
    int pageSize = 20,
  }) async {
    return await _repository.getWallpapersByCategory(
      categoryId,
      page: page,
      pageSize: pageSize,
    );
  }
}
