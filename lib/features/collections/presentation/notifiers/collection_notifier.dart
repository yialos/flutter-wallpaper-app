import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/collection.dart';
import '../../domain/usecases/create_collection_use_case.dart';
import '../../domain/usecases/delete_collection_use_case.dart';
import '../../domain/usecases/get_all_collections_use_case.dart';
import '../../domain/usecases/update_collection_use_case.dart';
import 'collection_state.dart';

/// State notifier for collections
class CollectionNotifier extends StateNotifier<CollectionState> {
  final GetAllCollectionsUseCase _getAllCollectionsUseCase;
  final CreateCollectionUseCase _createCollectionUseCase;
  final UpdateCollectionUseCase _updateCollectionUseCase;
  final DeleteCollectionUseCase _deleteCollectionUseCase;

  CollectionNotifier(
    this._getAllCollectionsUseCase,
    this._createCollectionUseCase,
    this._updateCollectionUseCase,
    this._deleteCollectionUseCase,
  ) : super(const CollectionState());

  /// Load all collections
  Future<void> loadCollections() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final collections = await _getAllCollectionsUseCase.execute();
      state = state.copyWith(collections: collections, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Create new collection
  Future<Collection?> createCollection({
    required String name,
    String description = '',
    String? coverImageUrl,
  }) async {
    try {
      final collection = await _createCollectionUseCase.execute(
        name: name,
        description: description,
        coverImageUrl: coverImageUrl,
      );

      // Reload collections
      await loadCollections();

      return collection;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Update collection
  Future<bool> updateCollection({
    required String collectionId,
    String? name,
    String? description,
    String? coverImageUrl,
  }) async {
    try {
      await _updateCollectionUseCase.execute(
        collectionId: collectionId,
        name: name,
        description: description,
        coverImageUrl: coverImageUrl,
      );

      // Reload collections
      await loadCollections();

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Delete collection
  Future<bool> deleteCollection(String collectionId) async {
    try {
      await _deleteCollectionUseCase.execute(collectionId);

      // Reload collections
      await loadCollections();

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
