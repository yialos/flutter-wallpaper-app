import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/core/network/network.dart';
import 'package:wallpaper_app/features/browse/data/datasources/wallpaper_remote_datasource.dart';
import 'package:wallpaper_app/features/browse/data/repositories/category_repository_impl.dart';
import 'package:wallpaper_app/features/browse/data/repositories/wallpaper_repository_impl.dart';
import 'package:wallpaper_app/features/browse/domain/repositories/category_repository.dart';
import 'package:wallpaper_app/features/browse/domain/repositories/wallpaper_repository.dart';
import 'package:wallpaper_app/features/browse/domain/usecases/browse_wallpapers_use_case.dart';
import 'package:wallpaper_app/features/browse/domain/usecases/filter_by_category_use_case.dart';
import 'package:wallpaper_app/features/browse/domain/usecases/get_categories_use_case.dart';
import 'package:wallpaper_app/features/browse/domain/usecases/get_wallpaper_by_id_use_case.dart';

/// Remote Data Source Provider
/// Requirements: 1.1, 2.1, 3.1
final wallpaperRemoteDataSourceProvider = Provider<WallpaperRemoteDataSource>((
  ref,
) {
  final networkClient = ref.watch(networkClientProvider);
  return WallpaperRemoteDataSourceImpl(networkClient: networkClient);
});

/// Wallpaper Repository Provider (singleton)
/// Requirements: 1.1, 2.1, 3.1, 4.1, 6.1, 7.1
final wallpaperRepositoryProvider = Provider<WallpaperRepository>((ref) {
  final remoteDataSource = ref.watch(wallpaperRemoteDataSourceProvider);

  return WallpaperRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Category Repository Provider (singleton)
/// Requirements: 3.1, 3.2
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final remoteDataSource = ref.watch(wallpaperRemoteDataSourceProvider);

  return CategoryRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Browse Wallpapers Use Case Provider
/// Requirements: 1.1, 1.2, 1.3, 1.4
final browseWallpapersUseCaseProvider = Provider<BrowseWallpapersUseCase>((
  ref,
) {
  final repository = ref.watch(wallpaperRepositoryProvider);
  return BrowseWallpapersUseCase(repository);
});

/// Get Wallpaper By ID Use Case Provider
/// Requirements: 1.1, 1.2, 1.3, 1.4
final getWallpaperByIdUseCaseProvider = Provider<GetWallpaperByIdUseCase>((
  ref,
) {
  final repository = ref.watch(wallpaperRepositoryProvider);
  return GetWallpaperByIdUseCase(repository);
});

/// Get Categories Use Case Provider
/// Requirements: 3.1, 3.2, 3.3, 3.4
final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

/// Filter By Category Use Case Provider
/// Requirements: 3.1, 3.2, 3.3, 3.4
final filterByCategoryUseCaseProvider = Provider<FilterByCategoryUseCase>((
  ref,
) {
  final repository = ref.watch(categoryRepositoryProvider);
  return FilterByCategoryUseCase(repository);
});
