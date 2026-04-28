import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../browse/domain/entities/wallpaper.dart';
import '../../../browse/presentation/providers/browse_providers.dart';
import '../../../../shared/widgets/wallpaper_thumbnail_widget.dart';
import '../../../detail/presentation/pages/wallpaper_detail_page.dart';
import '../../domain/entities/collection.dart';
import '../widgets/edit_collection_dialog.dart';

/// Page displaying collection details and wallpapers
class CollectionDetailPage extends ConsumerStatefulWidget {
  final Collection collection;

  const CollectionDetailPage({super.key, required this.collection});

  @override
  ConsumerState<CollectionDetailPage> createState() =>
      _CollectionDetailPageState();
}

class _CollectionDetailPageState extends ConsumerState<CollectionDetailPage> {
  final Map<String, Wallpaper?> _wallpaperCache = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWallpapers();
  }

  Future<void> _loadWallpapers() async {
    if (widget.collection.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final getWallpaperById = ref.read(getWallpaperByIdUseCaseProvider);

      // Load wallpapers in parallel
      await Future.wait(
        widget.collection.wallpaperIds.map((id) async {
          if (!_wallpaperCache.containsKey(id)) {
            try {
              final wallpaper = await getWallpaperById.execute(id);
              _wallpaperCache[id] = wallpaper;
            } catch (e) {
              _wallpaperCache[id] = null;
            }
          }
        }),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
            tooltip: 'Chỉnh sửa',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collection info
          if (widget.collection.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.collection.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${widget.collection.wallpaperCount} hình nền',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          // Wallpapers grid
          Expanded(
            child: widget.collection.isEmpty
                ? _buildEmptyState(context)
                : _buildWallpapersGrid(context),
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
            Icons.image_not_supported_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có hình nền nào',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm hình nền từ trang chi tiết',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildWallpapersGrid(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 9 / 16,
      ),
      itemCount: widget.collection.wallpaperIds.length,
      itemBuilder: (context, index) {
        final wallpaperId = widget.collection.wallpaperIds[index];
        final wallpaper = _wallpaperCache[wallpaperId];

        if (wallpaper == null) {
          // Show placeholder while loading or if failed
          return Card(
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
          );
        }

        return WallpaperThumbnailWidget(
          wallpaper: wallpaper,
          onTap: () => _navigateToDetail(context, wallpaper),
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context, Wallpaper wallpaper) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WallpaperDetailPage(wallpaper: wallpaper),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditCollectionDialog(collection: widget.collection),
    );
  }
}
