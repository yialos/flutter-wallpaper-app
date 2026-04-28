import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_local_datasource.dart';
import '../repositories/favorite_repository_impl.dart';

/// Provider for FavoriteLocalDataSource
/// Requirements: 6.2, 6.5
final favoriteLocalDataSourceProvider = Provider<FavoriteLocalDataSource>((
  ref,
) {
  return FavoriteLocalDataSource();
});

/// Provider for FavoriteRepository
/// Requirements: 6.2, 6.3, 6.4, 6.5
final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  final localDataSource = ref.watch(favoriteLocalDataSourceProvider);
  return FavoriteRepositoryImpl(localDataSource: localDataSource);
});
