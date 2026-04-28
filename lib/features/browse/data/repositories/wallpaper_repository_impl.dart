import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/wallpaper_remote_datasource.dart';
import '../models/wallpaper_dto.dart';

/// Implementation of WallpaperRepository with cache-first strategy
/// Requirements: 1.1, 2.1, 3.1, 6.2, 6.3, 6.4, 7.2
class WallpaperRepositoryImpl implements WallpaperRepository {
  final WallpaperRemoteDataSource remoteDataSource;

  const WallpaperRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedResult<Wallpaper>> getWallpapers({
    required int page,
    required int pageSize,
    String? category,
  }) async {
    // Fetch from remote data source
    final response = await remoteDataSource.getWallpapers(
      page: page,
      pageSize: pageSize,
      category: category,
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

  @override
  Future<Wallpaper> getWallpaperById(String id) async {
    // Fetch from remote data source
    final dto = await remoteDataSource.getWallpaperById(id);
    return dto.toDomain();
  }
}
