import 'package:equatable/equatable.dart';
import 'wallpaper_resolution.dart';

/// Domain entity representing a wallpaper
class Wallpaper extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String thumbnailUrl;
  final String fullResolutionUrl;
  final WallpaperResolution resolution;
  final List<String> categories;
  final String? author;
  final DateTime createdAt;

  const Wallpaper({
    required this.id,
    required this.title,
    this.description,
    required this.thumbnailUrl,
    required this.fullResolutionUrl,
    required this.resolution,
    required this.categories,
    this.author,
    required this.createdAt,
  });

  /// Create a copy of this wallpaper with updated fields
  Wallpaper copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? fullResolutionUrl,
    WallpaperResolution? resolution,
    List<String>? categories,
    String? author,
    DateTime? createdAt,
  }) {
    return Wallpaper(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fullResolutionUrl: fullResolutionUrl ?? this.fullResolutionUrl,
      resolution: resolution ?? this.resolution,
      categories: categories ?? this.categories,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    thumbnailUrl,
    fullResolutionUrl,
    resolution,
    categories,
    author,
    createdAt,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Wallpaper && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
