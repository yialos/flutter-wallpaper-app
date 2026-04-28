import 'package:equatable/equatable.dart';

/// Collection entity representing a wallpaper collection/album
class Collection extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> wallpaperIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? coverImageUrl;

  const Collection({
    required this.id,
    required this.name,
    required this.description,
    required this.wallpaperIds,
    required this.createdAt,
    required this.updatedAt,
    this.coverImageUrl,
  });

  /// Get number of wallpapers in collection
  int get wallpaperCount => wallpaperIds.length;

  /// Check if collection is empty
  bool get isEmpty => wallpaperIds.isEmpty;

  /// Check if collection contains a wallpaper
  bool containsWallpaper(String wallpaperId) {
    return wallpaperIds.contains(wallpaperId);
  }

  /// Create a copy with updated fields
  Collection copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? wallpaperIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? coverImageUrl,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      wallpaperIds: wallpaperIds ?? this.wallpaperIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    wallpaperIds,
    createdAt,
    updatedAt,
    coverImageUrl,
  ];
}
