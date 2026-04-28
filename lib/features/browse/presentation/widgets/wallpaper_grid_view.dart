import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/features/browse/domain/entities/wallpaper.dart';
import 'package:wallpaper_app/shared/widgets/wallpaper_thumbnail_widget.dart';

/// Grid view widget for displaying wallpapers with infinite scroll
/// Requirements: 1.1, 1.2, 1.4
class WallpaperGridView extends StatefulWidget {
  final List<Wallpaper> wallpapers;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final void Function(Wallpaper) onTapWallpaper;

  const WallpaperGridView({
    super.key,
    required this.wallpapers,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onTapWallpaper,
  });

  @override
  State<WallpaperGridView> createState() => _WallpaperGridViewState();
}

class _WallpaperGridViewState extends State<WallpaperGridView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Detect scroll to bottom and trigger load more
  /// Requirements: 1.2, 1.4
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoadingMore && !widget.isLoading) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator for initial load
    if (widget.isLoading && widget.wallpapers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show empty state if no wallpapers
    if (widget.wallpapers.isEmpty && !widget.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Không có hình nền',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: MasonryGridView.count(
        controller: _scrollController,
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        itemCount: widget.wallpapers.length + (widget.isLoadingMore ? 1 : 0),
        // Performance optimizations
        addAutomaticKeepAlives: false, // Don't keep offscreen items alive
        addRepaintBoundaries: true, // Add repaint boundaries automatically
        itemBuilder: (context, index) {
          // Show loading indicator at the bottom when loading more
          if (index == widget.wallpapers.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final wallpaper = widget.wallpapers[index];

          return WallpaperThumbnailWidget(
            wallpaper: wallpaper,
            onTap: () => widget.onTapWallpaper(wallpaper),
          );
        },
      ),
    );
  }
}
