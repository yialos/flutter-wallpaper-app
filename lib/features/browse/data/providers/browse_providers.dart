import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/wallpaper_remote_datasource.dart';
import '../repositories/wallpaper_repository_impl.dart';
import '../repositories/category_repository_impl.dart';

/// Provider for WallpaperRemoteDataSource
final wallpaperRemoteDataSourceProvider = Provider<WallpaperRemoteDataSource>((
  ref,
) {
  final networkClient = ref.watch(networkClientProvider);
  return WallpaperRemoteDataSourceImpl(networkClient: networkClient);
});

/// Provider for WallpaperRepository
final wallpaperRepositoryProvider = Provider<WallpaperRepository>((ref) {
  final remoteDataSource = ref.watch(wallpaperRemoteDataSourceProvider);
  return WallpaperRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Provider for CategoryRepository
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final remoteDataSource = ref.watch(wallpaperRemoteDataSourceProvider);
  return CategoryRepositoryImpl(remoteDataSource: remoteDataSource);
});
