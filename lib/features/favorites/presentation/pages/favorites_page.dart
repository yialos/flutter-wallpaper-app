import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../browse/domain/entities/wallpaper.dart';
import '../../../browse/presentation/providers/browse_providers.dart';
import '../../../detail/presentation/pages/wallpaper_detail_page.dart';
import '../../../../shared/widgets/wallpaper_thumbnail_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../notifiers/favorite_notifier.dart';

/// Page displaying favorite wallpapers
/// Requirements: 6.4
class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Load favorites on page initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteNotifierProvider.notifier).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteState = ref.watch(favoriteNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu thích'),
        actions: [
          if (favoriteState.favoriteIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearConfirmation(context),
              tooltip: 'Xóa tất cả',
            ),
        ],
      ),
      body: _buildBody(favoriteState),
    );
  }

  Widget _buildBody(FavoriteState favoriteState) {
    if (favoriteState.isLoading) {
      return const Center(child: LoadingIndicator(message: 'Đang tải...'));
    }

    if (favoriteState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              favoriteState.error!,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(favoriteNotifierProvider.notifier).loadFavorites();
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (favoriteState.favoriteIds.isEmpty) {
      return _buildEmptyState();
    }

    return _buildFavoritesGrid(favoriteState.favoriteIds);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Chưa có hình nền yêu thích',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhấn vào biểu tượng trái tim để thêm hình nền vào danh sách yêu thích',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid(Set<String> favoriteIds) {
    return FutureBuilder<List<Wallpaper>>(
      future: _getFavoriteWallpapers(favoriteIds.toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LoadingIndicator(message: 'Đang tải hình nền...'),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        final wallpapers = snapshot.data ?? [];

        if (wallpapers.isEmpty) {
          return _buildEmptyState();
        }

        return MasonryGridView.count(
          crossAxisCount: _getCrossAxisCount(context),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.all(8),
          itemCount: wallpapers.length,
          itemBuilder: (context, index) {
            final wallpaper = wallpapers[index];
            return WallpaperThumbnailWidget(
              wallpaper: wallpaper,
              onTap: () => _onTapWallpaper(wallpaper),
            );
          },
        );
      },
    );
  }

  Future<List<Wallpaper>> _getFavoriteWallpapers(
    List<String> favoriteIds,
  ) async {
    final repository = ref.read(wallpaperRepositoryProvider);
    final wallpapers = <Wallpaper>[];

    for (final id in favoriteIds) {
      try {
        final wallpaper = await repository.getWallpaperById(id);
        wallpapers.add(wallpaper);
      } catch (e) {
        // Skip wallpapers that can't be loaded
        continue;
      }
    }

    return wallpapers;
  }

  void _onTapWallpaper(Wallpaper wallpaper) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WallpaperDetailPage(wallpaper: wallpaper),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 6;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả yêu thích?'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa tất cả hình nền yêu thích? Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(favoriteNotifierProvider.notifier).clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa tất cả yêu thích')),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
