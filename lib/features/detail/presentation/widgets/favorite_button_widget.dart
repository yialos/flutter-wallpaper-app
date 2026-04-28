import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../browse/domain/entities/wallpaper.dart';
import '../../../favorites/presentation/providers/favorite_providers.dart';

/// Favorite button widget with Riverpod integration
/// Requirements: 6.1, 6.2, 6.3
class FavoriteButtonWidget extends ConsumerStatefulWidget {
  final Wallpaper wallpaper;
  final double iconSize;
  final bool showLabel;
  final Color? activeColor;
  final Color? inactiveColor;

  const FavoriteButtonWidget({
    super.key,
    required this.wallpaper,
    this.iconSize = 24.0,
    this.showLabel = false,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  ConsumerState<FavoriteButtonWidget> createState() =>
      _FavoriteButtonWidgetState();
}

class _FavoriteButtonWidgetState extends ConsumerState<FavoriteButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    // Animate the button
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Toggle favorite using wallpaper ID
    await ref
        .read(favoriteNotifierProvider.notifier)
        .toggleFavorite(widget.wallpaper.id);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteState = ref.watch(favoriteNotifierProvider);
    final isFavorite = favoriteState.isFavorite(widget.wallpaper.id);
    final activeColor = widget.activeColor ?? Colors.red;
    final inactiveColor =
        widget.inactiveColor ?? Colors.white.withValues(alpha: 0.7);

    // Semantic label for screen readers
    final semanticLabel = isFavorite
        ? 'Xóa ${widget.wallpaper.title} khỏi yêu thích'
        : 'Thêm ${widget.wallpaper.title} vào yêu thích';

    if (widget.showLabel) {
      return Semantics(
        label: semanticLabel,
        button: true,
        enabled: true,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: widget.iconSize,
                      color: isFavorite ? activeColor : inactiveColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isFavorite ? 'Đã thích' : 'Yêu thích',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: true,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: widget.iconSize,
            color: isFavorite ? activeColor : inactiveColor,
          ),
          onPressed: _handleTap,
          tooltip: isFavorite ? 'Xóa khỏi yêu thích' : 'Thêm vào yêu thích',
        ),
      ),
    );
  }
}
