import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/entities.dart';

part 'category_dto.g.dart';

/// Data Transfer Object for Category with JSON serialization
@JsonSerializable()
class CategoryDTO {
  final String id;
  final String name;
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @JsonKey(name: 'wallpaper_count')
  final int wallpaperCount;

  const CategoryDTO({
    required this.id,
    required this.name,
    this.iconUrl,
    required this.wallpaperCount,
  });

  /// Create DTO from JSON
  factory CategoryDTO.fromJson(Map<String, dynamic> json) =>
      _$CategoryDTOFromJson(json);

  /// Convert DTO to JSON
  Map<String, dynamic> toJson() => _$CategoryDTOToJson(this);

  /// Convert DTO to domain model
  Category toDomain() {
    return Category(
      id: id,
      name: name,
      iconUrl: iconUrl,
      wallpaperCount: wallpaperCount,
    );
  }

  /// Create DTO from domain model
  factory CategoryDTO.fromDomain(Category category) {
    return CategoryDTO(
      id: category.id,
      name: category.name,
      iconUrl: category.iconUrl,
      wallpaperCount: category.wallpaperCount,
    );
  }
}
