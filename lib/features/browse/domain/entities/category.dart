import 'package:equatable/equatable.dart';

/// Domain entity representing a wallpaper category
class Category extends Equatable {
  final String id;
  final String name;
  final String? iconUrl;
  final int wallpaperCount;

  const Category({
    required this.id,
    required this.name,
    this.iconUrl,
    required this.wallpaperCount,
  });

  /// Create a copy of this category with updated fields
  Category copyWith({
    String? id,
    String? name,
    String? iconUrl,
    int? wallpaperCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      wallpaperCount: wallpaperCount ?? this.wallpaperCount,
    );
  }

  @override
  List<Object?> get props => [id, name, iconUrl, wallpaperCount];
}
