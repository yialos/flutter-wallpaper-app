import '../repositories/collection_repository.dart';

/// Use case for updating a collection
class UpdateCollectionUseCase {
  final CollectionRepository _repository;

  UpdateCollectionUseCase(this._repository);

  /// Execute update collection
  Future<void> execute({
    required String collectionId,
    String? name,
    String? description,
    String? coverImageUrl,
  }) async {
    final collection = await _repository.getCollectionById(collectionId);

    if (collection == null) {
      throw ArgumentError('Collection không tồn tại');
    }

    final updatedCollection = collection.copyWith(
      name: name ?? collection.name,
      description: description ?? collection.description,
      coverImageUrl: coverImageUrl ?? collection.coverImageUrl,
      updatedAt: DateTime.now(),
    );

    await _repository.updateCollection(updatedCollection);
  }
}
