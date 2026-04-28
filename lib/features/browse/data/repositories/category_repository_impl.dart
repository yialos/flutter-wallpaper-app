import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/wallpaper_remote_datasource.dart';
import '../models/wallpaper_dto.dart';

/// Implementation of CategoryRepository
/// Requirements: 3.1, 3.2, 6.2, 6.3, 6.4, 7.2
class CategoryRepositoryImpl implements CategoryRepository {
  final WallpaperRemoteDataSource remoteDataSource;

  const CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> getCategories() async {
    // Fetch from remote data source
    final dtos = await remoteDataSource.getCategories();

    // Convert DTOs to domain models
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<PaginatedResult<Wallpaper>> getWallpapersByCategory(
    String categoryId, {
    required int page,
    required int pageSize,
  }) async {
    // Fetch from remote data source using category filter
    final response = await remoteDataSource.getWallpapers(
      page: page,
      pageSize: pageSize,
      category: categoryId,
    );

    // Parse response
    final items = response['items'] as List<dynamic>?;
    final currentPage = response['currentPage'] as int? ?? page;
    final totalPages = response['totalPages'] as int? ?? 1;
    final hasMore = response['hasMore'] as bool? ?? false;

    // Convert DTOs to domain models
    final wallpapers =
        items
            ?.map((json) => WallpaperDTO.fromJson(json as Map<String, dynamic>))
            .map((dto) => dto.toDomain())
            .toList() ??
        [];

    return PaginatedResult<Wallpaper>(
      items: wallpapers,
      currentPage: currentPage,
      totalPages: totalPages,
      hasMore: hasMore,
    );
  }
}
