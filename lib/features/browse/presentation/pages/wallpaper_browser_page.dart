import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/core/network/connectivity_providers.dart';
import 'package:wallpaper_app/core/utils/edge_case_handler.dart';
import 'package:wallpaper_app/features/browse/domain/entities/wallpaper.dart';
import 'package:wallpaper_app/features/browse/presentation/notifiers/wallpaper_browser_notifier.dart';
import 'package:wallpaper_app/features/browse/presentation/widgets/wallpaper_grid_view.dart';
import 'package:wallpaper_app/features/search/presentation/pages/search_page.dart';
import 'package:wallpaper_app/features/category/presentation/widgets/category_filter_widget.dart';
import 'package:wallpaper_app/features/category/presentation/providers/category_providers.dart';
import 'package:wallpaper_app/features/detail/presentation/pages/wallpaper_detail_page.dart';
import 'package:wallpaper_app/shared/widgets/error_message_widget.dart';
import 'package:wallpaper_app/shared/widgets/offline_indicator.dart';
import 'package:wallpaper_app/shared/widgets/first_launch_offline_widget.dart';

/// Main page for browsing wallpapers
/// Requirements: 1.1, 1.5, 2.1
class WallpaperBrowserPage extends ConsumerStatefulWidget {
  const WallpaperBrowserPage({super.key});

  @override
  ConsumerState<WallpaperBrowserPage> createState() =>
      _WallpaperBrowserPageState();
}

class _WallpaperBrowserPageState extends ConsumerState<WallpaperBrowserPage> {
  bool _isFirstLaunch = false;
  bool _checkedFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    // Check if first launch and load wallpapers
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check first launch
      _isFirstLaunch = await EdgeCaseHandler.isFirstLaunch();
      _checkedFirstLaunch = true;

      if (mounted) {
        setState(() {});

        // Load wallpapers
        ref.read(wallpaperBrowserNotifierProvider.notifier).loadWallpapers();
      }
    });
  }

  void _onCategorySelected(String? categoryId) {
    // Filter wallpapers by category
    ref
        .read(wallpaperBrowserNotifierProvider.notifier)
        .filterByCategory(categoryId);

    // Update selected category state
    ref.read(selectedCategoryProvider.notifier).state = categoryId;
  }

  void _onTapWallpaper(Wallpaper wallpaper) {
    // Navigate to wallpaper detail page with Hero animation
    // Requirements: 1.3
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WallpaperDetailPage(wallpaper: wallpaper),
      ),
    );
  }

  void _onSearchTap() {
    // Navigate to search page
    // Requirements: 2.1, 2.5
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wallpaperBrowserNotifierProvider);
    final notifier = ref.read(wallpaperBrowserNotifierProvider.notifier);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hình nền'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchTap,
            tooltip: 'Tìm kiếm',
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline indicator
          const AnimatedOfflineIndicator(),

          // Category filter
          CategoryFilterWidget(
            selectedCategoryId: selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),

          // Wallpaper grid
          Expanded(child: _buildBody(state, notifier)),
        ],
      ),
    );
  }

  Widget _buildBody(
    WallpaperBrowserState state,
    WallpaperBrowserNotifier notifier,
  ) {
    final isOnline = ref.watch(isOnlineProvider);

    // Show first launch offline message if applicable
    if (_checkedFirstLaunch &&
        _isFirstLaunch &&
        !isOnline &&
        state.wallpapers.isEmpty) {
      return FirstLaunchOfflineWidget(onRetry: () => notifier.loadWallpapers());
    }

    // Show error message if there's an error
    if (state.error != null && state.wallpapers.isEmpty) {
      return Center(
        child: ErrorMessageWidget(
          message: state.error!,
          onRetry: () => notifier.loadWallpapers(),
        ),
      );
    }

    // Show wallpaper grid
    return WallpaperGridView(
      wallpapers: state.wallpapers,
      isLoading: state.isLoading,
      isLoadingMore: state.isLoadingMore,
      hasMore: state.hasMore,
      onLoadMore: () => notifier.loadMore(),
      onRefresh: () => notifier.refresh(),
      onTapWallpaper: _onTapWallpaper,
    );
  }
}
