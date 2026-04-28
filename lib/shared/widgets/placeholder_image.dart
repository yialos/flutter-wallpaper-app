import 'package:flutter/material.dart';

/// Placeholder widget for image loading
class PlaceholderImage extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;

  const PlaceholderImage({super.key, this.width, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color ?? Colors.grey[300],
      child: Center(
        child: Icon(Icons.image, size: 48, color: Colors.grey[400]),
      ),
    );
  }
}
