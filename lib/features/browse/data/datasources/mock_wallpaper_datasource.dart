import '../models/wallpaper_dto.dart';
import '../models/category_dto.dart';

/// Mock data source for testing without API
class MockWallpaperDataSource {
  static List<Map<String, dynamic>> getMockWallpapers({
    required int page,
    required int pageSize,
  }) {
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    final allWallpapers = List.generate(100, (index) {
      final id = 'mock_${index + 1}';
      // Use seed instead of random to get consistent images
      final seed = index + 1000; // Add offset to get different images
      return {
        'id': id,
        'title': 'Hình nền đẹp ${index + 1}',
        'description': 'Mô tả cho hình nền số ${index + 1}',
        'thumbnail_url': 'https://picsum.photos/seed/$seed/400/700',
        'full_url': 'https://picsum.photos/seed/$seed/1080/1920',
        'width': 1080,
        'height': 1920,
        'categories': _getRandomCategories(index),
        'author': 'Tác giả ${(index % 10) + 1}',
        'created_at': DateTime.now()
            .subtract(Duration(days: index))
            .toIso8601String(),
      };
    });

    if (startIndex >= allWallpapers.length) {
      return [];
    }

    final end = endIndex > allWallpapers.length
        ? allWallpapers.length
        : endIndex;
    return allWallpapers.sublist(startIndex, end);
  }

  static List<String> _getRandomCategories(int index) {
    final categories = [
      'Thiên nhiên',
      'Thành phố',
      'Động vật',
      'Nghệ thuật',
      'Trừu tượng',
      'Phong cảnh',
      'Công nghệ',
      'Thể thao',
      'Ẩm thực',
      'Du lịch',
    ];
    return [categories[index % categories.length]];
  }

  static List<CategoryDTO> getMockCategories() {
    return [
      const CategoryDTO(
        id: 'nature',
        name: 'Thiên nhiên',
        iconUrl: null,
        wallpaperCount: 25,
      ),
      const CategoryDTO(
        id: 'city',
        name: 'Thành phố',
        iconUrl: null,
        wallpaperCount: 20,
      ),
      const CategoryDTO(
        id: 'animals',
        name: 'Động vật',
        iconUrl: null,
        wallpaperCount: 15,
      ),
      const CategoryDTO(
        id: 'art',
        name: 'Nghệ thuật',
        iconUrl: null,
        wallpaperCount: 18,
      ),
      const CategoryDTO(
        id: 'abstract',
        name: 'Trừu tượng',
        iconUrl: null,
        wallpaperCount: 22,
      ),
      const CategoryDTO(
        id: 'landscape',
        name: 'Phong cảnh',
        iconUrl: null,
        wallpaperCount: 30,
      ),
      const CategoryDTO(
        id: 'technology',
        name: 'Công nghệ',
        iconUrl: null,
        wallpaperCount: 12,
      ),
      const CategoryDTO(
        id: 'sports',
        name: 'Thể thao',
        iconUrl: null,
        wallpaperCount: 10,
      ),
      const CategoryDTO(
        id: 'food',
        name: 'Ẩm thực',
        iconUrl: null,
        wallpaperCount: 8,
      ),
      const CategoryDTO(
        id: 'travel',
        name: 'Du lịch',
        iconUrl: null,
        wallpaperCount: 28,
      ),
    ];
  }

  static List<WallpaperDTO> searchMockWallpapers(String query) {
    return List.generate(10, (index) {
      final id = 'search_${index + 1}';
      // Use seed for consistent images
      final seed = query.hashCode.abs() + index + 2000;
      return WallpaperDTO(
        id: id,
        title: '$query ${index + 1}',
        description: 'Kết quả tìm kiếm cho "$query"',
        thumbnailUrl:
            'https://picsum.photos/seed/$seed/400/700',
        fullResolutionUrl:
            'https://picsum.photos/seed/$seed/1080/1920',
        width: 1080,
        height: 1920,
        categories: [query],
        author: 'Tác giả ${index + 1}',
        createdAt: DateTime.now().toIso8601String(),
      );
    });
  }
}
