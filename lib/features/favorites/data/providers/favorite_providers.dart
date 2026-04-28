import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_local_datasource.dart';
import '../repositories/favorite_repository_impl.dart';

/// Provider for FavoriteLocalDataSource
final favoriteLocalDataSourceProvider = Provider<FavoriteLocalDataSource>((
  ref,
) {
  final dataSource = FavoriteLocalDataSource();
  ref.onDispose(() {
    // Dispose if needed
  });
  return dataSource;
});

/// Provider for FavoriteRepository
final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  final localDataSource = ref.watch(favoriteLocalDataSourceProvider);
  return FavoriteRepositoryImpl(localDataSource: localDataSource);
});

/// Provider for favorites stream
final favoritesStreamProvider = StreamProvider<List<String>>((ref) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return repository.watchFavorites();
});
