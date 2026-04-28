import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_local_datasource.dart';

/// Implementation of FavoriteRepository using Hive
/// Requirements: 6.2, 6.3, 6.4, 6.5
class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteLocalDataSource _localDataSource;

  FavoriteRepositoryImpl({required FavoriteLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<List<String>> getFavoriteIds() async {
    return await _localDataSource.getFavoriteIds();
  }

  @override
  Future<void> addFavorite(String wallpaperId) async {
    await _localDataSource.addFavorite(wallpaperId);
  }

  @override
  Future<void> removeFavorite(String wallpaperId) async {
    await _localDataSource.removeFavorite(wallpaperId);
  }

  @override
  Future<bool> isFavorite(String wallpaperId) async {
    return await _localDataSource.isFavorite(wallpaperId);
  }

  @override
  Stream<List<String>> watchFavorites() {
    return _localDataSource.watchFavorites();
  }

  @override
  Future<void> clearAll() async {
    await _localDataSource.clearAll();
  }
}
