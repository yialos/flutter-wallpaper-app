import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../browse/domain/entities/wallpaper.dart';
import '../widgets/wallpaper_info_sheet.dart';
import '../widgets/wallpaper_action_buttons.dart';

/// Full-screen wallpaper detail page with zoom/pan
/// Requirements: 1.3, 4.1, 5.1, 6.1
class WallpaperDetailPage extends ConsumerStatefulWidget {
  final Wallpaper wallpaper;

  const WallpaperDetailPage({super.key, required this.wallpaper});

  @override
  ConsumerState<WallpaperDetailPage> createState() =>
      _WallpaperDetailPageState();
}

class _WallpaperDetailPageState extends ConsumerState<WallpaperDetailPage> {
  final TransformationController _transformationController =
      TransformationController();
  bool _showUI = true;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _toggleUI() {
    setState(() {
      _showUI = !_showUI;
    });
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen zoomable image
          GestureDetector(
            onTap: _toggleUI,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Hero(
                  tag: 'wallpaper_${widget.wallpaper.id}',
                  child: CachedNetworkImage(
                    imageUrl: widget.wallpaper.fullResolutionUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => CachedNetworkImage(
                      imageUrl: widget.wallpaper.thumbnailUrl,
                      fit: BoxFit.contain,
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Top bar with back button and info
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: _showUI ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.wallpaper.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${widget.wallpaper.resolution.width} x ${widget.wallpaper.resolution.height}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        onPressed: () => _showInfoSheet(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom action buttons
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _showUI ? 0 : -200,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                ),
              ),
              child: SafeArea(
                child: WallpaperActionButtons(
                  wallpaper: widget.wallpaper,
                  onResetZoom: _resetZoom,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => WallpaperInfoSheet(wallpaper: widget.wallpaper),
    );
  }
}
