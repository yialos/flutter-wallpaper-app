import 'package:wallpaper_app/core/network/network_client.dart';
import '../models/wallpaper_dto.dart';
import '../models/category_dto.dart';
import 'mock_wallpaper_datasource.dart';

/// Remote data source for wallpaper operations
/// Requirements: 1.1, 1.2, 2.1, 2.2, 3.1
abstract class WallpaperRemoteDataSource {
  /// Get paginated wallpapers from API
  Future<Map<String, dynamic>> getWallpapers({
    required int page,
    required int pageSize,
    String? category,
  });

  /// Search wallpapers by query
  Future<List<WallpaperDTO>> searchWallpapers({
    required String query,
    int? limit,
  });

  /// Get all categories
  Future<List<CategoryDTO>> getCategories();

  /// Get wallpaper by ID
  Future<WallpaperDTO> getWallpaperById(String id);
}

/// Implementation of WallpaperRemoteDataSource using Dio
class WallpaperRemoteDataSourceImpl implements WallpaperRemoteDataSource {
  final NetworkClient networkClient;

  const WallpaperRemoteDataSourceImpl({required this.networkClient});

  @override
  Future<Map<String, dynamic>> getWallpapers({
    required int page,
    required int pageSize,
    String? category,
  }) async {
    // Use mock data for now
    var mockItems = MockWallpaperDataSource.getMockWallpapers(
      page: page,
      pageSize: pageSize,
    );

    // Filter by category if specified
    if (category != null && category.isNotEmpty) {
      // Get category name from ID
      final categories = MockWallpaperDataSource.getMockCategories();
      final categoryName = categories
          .firstWhere(
            (c) => c.id == category,
            orElse: () => categories.first,
          )
          .name;

      // Filter wallpapers by category name
      mockItems = mockItems.where((item) {
        final itemCategories = item['categories'] as List<String>;
        return itemCategories.contains(categoryName);
      }).toList();
    }

    return {
      'items': mockItems,
      'currentPage': page,
      'totalPages': 5,
      'hasMore': mockItems.length >= pageSize,
    };
  }

  @override
  Future<List<WallpaperDTO>> searchWallpapers({
    required String query,
    int? limit,
  }) async {
    // Use mock data for now
    return MockWallpaperDataSource.searchMockWallpapers(query);
  }

  @override
  Future<List<CategoryDTO>> getCategories() async {
    // Use mock data for now
    return MockWallpaperDataSource.getMockCategories();
  }

  @override
  Future<WallpaperDTO> getWallpaperById(String id) async {
    // Use mock data for now
    final mockWallpapers = MockWallpaperDataSource.getMockWallpapers(
      page: 1,
      pageSize: 100,
    );

    final wallpaperData = mockWallpapers.firstWhere(
      (w) => w['id'] == id,
      orElse: () => mockWallpapers.first,
    );

    return WallpaperDTO.fromJson(wallpaperData);
  }
}
