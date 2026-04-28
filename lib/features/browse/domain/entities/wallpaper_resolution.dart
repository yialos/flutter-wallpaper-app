import 'package:equatable/equatable.dart';

/// Represents the resolution of a wallpaper image
class WallpaperResolution extends Equatable {
  final int width;
  final int height;

  const WallpaperResolution(this.width, this.height);

  /// Calculate aspect ratio (width / height)
  double get aspectRatio => width / height;

  /// Check if this resolution is higher than another resolution
  /// Comparison is based on total pixel count (width * height)
  bool isHigherThan(WallpaperResolution other) {
    return width * height > other.width * other.height;
  }

  @override
  List<Object?> get props => [width, height];

  @override
  String toString() => '${width}x$height';
}
