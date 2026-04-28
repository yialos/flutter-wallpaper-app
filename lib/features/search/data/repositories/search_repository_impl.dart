import '../../../browse/domain/entities/entities.dart';
import '../../../browse/data/datasources/wallpaper_remote_datasource.dart';
import '../../domain/repositories/search_repository.dart';

/// Implementation of SearchRepository with debouncing
/// Requirements: 2.1, 2.2, 6.2, 6.3, 6.4, 7.2
class SearchRepositoryImpl implements SearchRepository {
  final WallpaperRemoteDataSource remoteDataSource;

  const SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Wallpaper>> searchWallpapers({
    required String query,
    int? limit,
  }) async {
    // Fetch from remote data source
    final dtos = await remoteDataSource.searchWallpapers(
      query: query,
      limit: limit,
    );

    // Convert DTOs to domain models
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
