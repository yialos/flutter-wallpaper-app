import 'package:flutter/material.dart';

/// Button widget for toggling favorite status
class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onToggle;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
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

  void _handleTap() {
    // Animate the button
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Call the toggle callback
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? Colors.red;
    final inactiveColor = widget.inactiveColor ?? Colors.grey[400]!;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          size: widget.size,
          color: widget.isFavorite ? activeColor : inactiveColor,
        ),
        onPressed: _handleTap,
        tooltip: widget.isFavorite
            ? 'Xóa khỏi yêu thích'
            : 'Thêm vào yêu thích',
      ),
    );
  }
}

/// Compact favorite icon without button padding
class CompactFavoriteIcon extends StatelessWidget {
  final bool isFavorite;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const CompactFavoriteIcon({
    super.key,
    required this.isFavorite,
    this.size = 20.0,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = this.activeColor ?? Colors.red;
    final inactiveColor = this.inactiveColor ?? Colors.grey[400]!;

    return Icon(
      isFavorite ? Icons.favorite : Icons.favorite_border,
      size: size,
      color: isFavorite ? activeColor : inactiveColor,
    );
  }
}
