import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/features/browse/presentation/providers/browse_providers.dart';
import 'package:wallpaper_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:wallpaper_app/features/search/domain/repositories/search_repository.dart';
import 'package:wallpaper_app/features/search/domain/usecases/search_wallpapers_use_case.dart';
import 'package:wallpaper_app/features/search/domain/utils/search_query_debouncer.dart';

/// Search Repository Provider (singleton)
/// Requirements: 2.1, 2.2
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final remoteDataSource = ref.watch(wallpaperRemoteDataSourceProvider);
  return SearchRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Search Query Debouncer Provider
/// Requirements: 2.1, 2.4, 2.5
final searchQueryDebouncerProvider = Provider<SearchQueryDebouncer>((ref) {
  return SearchQueryDebouncer(delay: const Duration(milliseconds: 500));
});

/// Search Wallpapers Use Case Provider
/// Requirements: 2.1, 2.2, 2.3, 2.4, 2.5
final searchWallpapersUseCaseProvider = Provider<SearchWallpapersUseCase>((
  ref,
) {
  final repository = ref.watch(searchRepositoryProvider);
  final debouncer = ref.watch(searchQueryDebouncerProvider);
  return SearchWallpapersUseCase(repository, debouncer: debouncer);
});
