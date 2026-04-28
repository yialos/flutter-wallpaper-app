import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_message_widget.dart';
import '../../../../shared/widgets/wallpaper_thumbnail_widget.dart';
import '../../../detail/presentation/pages/wallpaper_detail_page.dart';
import '../notifiers/search_state.dart';

/// Search results view
/// Requirements: 2.2, 2.3
class SearchResultsView extends StatelessWidget {
  final SearchState searchState;

  const SearchResultsView({super.key, required this.searchState});

  @override
  Widget build(BuildContext context) {
    return searchState.when(
      initial: () => _buildInitialState(context),
      loading: () =>
          const Center(child: LoadingIndicator(message: 'Đang tìm kiếm...')),
      loaded: (wallpapers) {
        if (wallpapers.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildResultsGrid(context, wallpapers);
      },
      error: (message) =>
          Center(child: ErrorMessageWidget(message: message, onRetry: null)),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Theme.of(context).disabledColor),
          const SizedBox(height: 16),
          Text(
            'Nhập từ khóa để tìm kiếm',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tìm kiếm hình nền theo chủ đề, màu sắc, hoặc từ khóa',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy kết quả',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thử tìm kiếm với từ khóa khác',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsGrid(BuildContext context, List<dynamic> wallpapers) {
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WallpaperDetailPage(wallpaper: wallpaper),
              ),
            );
          },
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 6;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }
}
