import 'package:hive/hive.dart';
import '../../domain/entities/collection.dart';

part 'collection_entity.g.dart';

/// Hive entity for storing collections locally
@HiveType(typeId: 2)
class CollectionEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<String> wallpaperIds;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final String? coverImageUrl;

  CollectionEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.wallpaperIds,
    required this.createdAt,
    required this.updatedAt,
    this.coverImageUrl,
  });

  /// Convert to domain entity
  Collection toDomain() {
    return Collection(
      id: id,
      name: name,
      description: description,
      wallpaperIds: wallpaperIds,
      createdAt: createdAt,
      updatedAt: updatedAt,
      coverImageUrl: coverImageUrl,
    );
  }

  /// Create from domain entity
  factory CollectionEntity.fromDomain(Collection collection) {
    return CollectionEntity(
      id: collection.id,
      name: collection.name,
      description: collection.description,
      wallpaperIds: collection.wallpaperIds,
      createdAt: collection.createdAt,
      updatedAt: collection.updatedAt,
      coverImageUrl: collection.coverImageUrl,
    );
  }
}
