import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/entities.dart';

part 'wallpaper_dto.g.dart';

/// Data Transfer Object for Wallpaper with JSON serialization
@JsonSerializable()
class WallpaperDTO {
  final String id;
  final String title;
  final String? description;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  @JsonKey(name: 'full_url')
  final String fullResolutionUrl;
  final int width;
  final int height;
  final List<String> categories;
  final String? author;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const WallpaperDTO({
    required this.id,
    required this.title,
    this.description,
    required this.thumbnailUrl,
    required this.fullResolutionUrl,
    required this.width,
    required this.height,
    required this.categories,
    this.author,
    required this.createdAt,
  });

  /// Create DTO from JSON
  factory WallpaperDTO.fromJson(Map<String, dynamic> json) =>
      _$WallpaperDTOFromJson(json);

  /// Convert DTO to JSON
  Map<String, dynamic> toJson() => _$WallpaperDTOToJson(this);

  /// Convert DTO to domain model
  Wallpaper toDomain() {
    return Wallpaper(
      id: id,
      title: title,
      description: description,
      thumbnailUrl: thumbnailUrl,
      fullResolutionUrl: fullResolutionUrl,
      resolution: WallpaperResolution(width, height),
      categories: categories,
      author: author,
      createdAt: DateTime.parse(createdAt),
    );
  }

  /// Create DTO from domain model
  factory WallpaperDTO.fromDomain(Wallpaper wallpaper) {
    return WallpaperDTO(
      id: wallpaper.id,
      title: wallpaper.title,
      description: wallpaper.description,
      thumbnailUrl: wallpaper.thumbnailUrl,
      fullResolutionUrl: wallpaper.fullResolutionUrl,
      width: wallpaper.resolution.width,
      height: wallpaper.resolution.height,
      categories: wallpaper.categories,
      author: wallpaper.author,
      createdAt: wallpaper.createdAt.toIso8601String(),
    );
  }
}
