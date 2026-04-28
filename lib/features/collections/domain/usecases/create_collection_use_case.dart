import '../entities/collection.dart';
import '../repositories/collection_repository.dart';

/// Use case for creating a new collection
class CreateCollectionUseCase {
  final CollectionRepository _repository;

  CreateCollectionUseCase(this._repository);

  /// Execute create collection
  ///
  /// [name] - Collection name
  /// [description] - Collection description
  /// [coverImageUrl] - Optional cover image URL
  Future<Collection> execute({
    required String name,
    String description = '',
    String? coverImageUrl,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Tên collection không được để trống');
    }

    // Generate ID using timestamp + random
    final id = '${DateTime.now().millisecondsSinceEpoch}_${name.hashCode}';

    final collection = Collection(
      id: id,
      name: name.trim(),
      description: description.trim(),
      wallpaperIds: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      coverImageUrl: coverImageUrl,
    );

    await _repository.createCollection(collection);
    return collection;
  }
}
