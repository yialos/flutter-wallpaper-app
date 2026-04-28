import '../entities/collection.dart';
import '../repositories/collection_repository.dart';

/// Use case for getting all collections
class GetAllCollectionsUseCase {
  final CollectionRepository _repository;

  GetAllCollectionsUseCase(this._repository);

  /// Execute get all collections
  /// Returns list sorted by updated date (newest first)
  Future<List<Collection>> execute() async {
    final collections = await _repository.getAllCollections();

    // Sort by updated date (newest first)
    collections.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return collections;
  }
}
