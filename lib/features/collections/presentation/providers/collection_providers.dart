import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/collection_local_datasource.dart';
import '../../data/repositories/collection_repository_impl.dart';
import '../../domain/entities/collection.dart';
import '../../domain/repositories/collection_repository.dart';
import '../../domain/usecases/add_wallpaper_to_collection_use_case.dart';
import '../../domain/usecases/create_collection_use_case.dart';
import '../../domain/usecases/delete_collection_use_case.dart';
import '../../domain/usecases/get_all_collections_use_case.dart';
import '../../domain/usecases/get_collections_containing_wallpaper_use_case.dart';
import '../../domain/usecases/remove_wallpaper_from_collection_use_case.dart';
import '../../domain/usecases/update_collection_use_case.dart';
import '../notifiers/collection_notifier.dart';
import '../notifiers/collection_state.dart';

/// Provider for CollectionLocalDataSource
final collectionLocalDataSourceProvider = Provider<CollectionLocalDataSource>((
  ref,
) {
  return CollectionLocalDataSource();
});

/// Provider for CollectionRepository
final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  final localDataSource = ref.watch(collectionLocalDataSourceProvider);
  return CollectionRepositoryImpl(localDataSource: localDataSource);
});

/// Provider for CreateCollectionUseCase
final createCollectionUseCaseProvider = Provider<CreateCollectionUseCase>((
  ref,
) {
  final repository = ref.watch(collectionRepositoryProvider);
  return CreateCollectionUseCase(repository);
});

/// Provider for GetAllCollectionsUseCase
final getAllCollectionsUseCaseProvider = Provider<GetAllCollectionsUseCase>((
  ref,
) {
  final repository = ref.watch(collectionRepositoryProvider);
  return GetAllCollectionsUseCase(repository);
});

/// Provider for DeleteCollectionUseCase
final deleteCollectionUseCaseProvider = Provider<DeleteCollectionUseCase>((
  ref,
) {
  final repository = ref.watch(collectionRepositoryProvider);
  return DeleteCollectionUseCase(repository);
});

/// Provider for UpdateCollectionUseCase
final updateCollectionUseCaseProvider = Provider<UpdateCollectionUseCase>((
  ref,
) {
  final repository = ref.watch(collectionRepositoryProvider);
  return UpdateCollectionUseCase(repository);
});

/// Provider for AddWallpaperToCollectionUseCase
final addWallpaperToCollectionUseCaseProvider =
    Provider<AddWallpaperToCollectionUseCase>((ref) {
      final repository = ref.watch(collectionRepositoryProvider);
      return AddWallpaperToCollectionUseCase(repository);
    });

/// Provider for RemoveWallpaperFromCollectionUseCase
final removeWallpaperFromCollectionUseCaseProvider =
    Provider<RemoveWallpaperFromCollectionUseCase>((ref) {
      final repository = ref.watch(collectionRepositoryProvider);
      return RemoveWallpaperFromCollectionUseCase(repository);
    });

/// Provider for GetCollectionsContainingWallpaperUseCase
final getCollectionsContainingWallpaperUseCaseProvider =
    Provider<GetCollectionsContainingWallpaperUseCase>((ref) {
      final repository = ref.watch(collectionRepositoryProvider);
      return GetCollectionsContainingWallpaperUseCase(repository);
    });

/// Stream provider for collections
final collectionsStreamProvider = StreamProvider<List<Collection>>((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.watchCollections();
});

/// Provider for collection count
final collectionCountProvider = Provider<int>((ref) {
  final collectionsAsync = ref.watch(collectionsStreamProvider);
  return collectionsAsync.when(
    data: (collections) => collections.length,
    loading: () => 0,
    error: (_, _) => 0,
  );
});

/// Provider for CollectionNotifier
final collectionNotifierProvider =
    StateNotifierProvider<CollectionNotifier, CollectionState>((ref) {
      final getAllCollectionsUseCase = ref.watch(
        getAllCollectionsUseCaseProvider,
      );
      final createCollectionUseCase = ref.watch(
        createCollectionUseCaseProvider,
      );
      final updateCollectionUseCase = ref.watch(
        updateCollectionUseCaseProvider,
      );
      final deleteCollectionUseCase = ref.watch(
        deleteCollectionUseCaseProvider,
      );

      return CollectionNotifier(
        getAllCollectionsUseCase,
        createCollectionUseCase,
        updateCollectionUseCase,
        deleteCollectionUseCase,
      );
    });
