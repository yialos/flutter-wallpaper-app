import '../repositories/collection_repository.dart';

/// Use case for deleting a collection
class DeleteCollectionUseCase {
  final CollectionRepository _repository;

  DeleteCollectionUseCase(this._repository);

  /// Execute delete collection
  Future<void> execute(String collectionId) async {
    await _repository.deleteCollection(collectionId);
  }
}
