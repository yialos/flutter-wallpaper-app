import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/features/browse/domain/entities/entities.dart';
import 'package:wallpaper_app/features/browse/domain/usecases/browse_wallpapers_use_case.dart';
import 'package:wallpaper_app/features/browse/presentation/providers/browse_providers.dart';

/// State class for wallpaper browser
/// Requirements: 1.1, 1.2
class WallpaperBrowserState {
  final List<Wallpaper> wallpapers;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String? selectedCategory;

  const WallpaperBrowserState({
    this.wallpapers = const [],
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.selectedCategory,
  });

  WallpaperBrowserState copyWith({
    List<Wallpaper>? wallpapers,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? selectedCategory,
    bool clearError = false,
  }) {
    return WallpaperBrowserState(
      wallpapers: wallpapers ?? this.wallpapers,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

/// State notifier for wallpaper browsing with pagination
/// Requirements: 1.1, 1.2, 3.2
class WallpaperBrowserNotifier extends StateNotifier<WallpaperBrowserState> {
  final BrowseWallpapersUseCase _browseWallpapersUseCase;
  static const int _pageSize = 20;

  WallpaperBrowserNotifier(this._browseWallpapersUseCase)
    : super(const WallpaperBrowserState());

  /// Load initial wallpapers
  /// Requirements: 1.1, 1.4
  Future<void> loadWallpapers() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _browseWallpapersUseCase.execute(
        page: 1,
        pageSize: _pageSize,
        category: state.selectedCategory,
      );

      state = WallpaperBrowserState(
        wallpapers: result.items,
        currentPage: result.currentPage,
        hasMore: result.hasMore,
        isLoading: false,
        selectedCategory: state.selectedCategory,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load more wallpapers (pagination)
  /// Requirements: 1.2, 1.4
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final nextPage = state.currentPage + 1;
      final result = await _browseWallpapersUseCase.execute(
        page: nextPage,
        pageSize: _pageSize,
        category: state.selectedCategory,
      );

      state = state.copyWith(
        wallpapers: [...state.wallpapers, ...result.items],
        currentPage: result.currentPage,
        hasMore: result.hasMore,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  /// Refresh wallpapers (pull-to-refresh)
  /// Requirements: 1.1
  Future<void> refresh() async {
    state = const WallpaperBrowserState();
    await loadWallpapers();
  }

  /// Filter wallpapers by category
  /// Requirements: 3.2
  Future<void> filterByCategory(String? categoryId) async {
    if (state.selectedCategory == categoryId) return;

    state = WallpaperBrowserState(selectedCategory: categoryId);
    await loadWallpapers();
  }

  /// Clear any error state
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for WallpaperBrowserNotifier
/// Requirements: 1.1, 1.2, 3.2
final wallpaperBrowserNotifierProvider =
    StateNotifierProvider<WallpaperBrowserNotifier, WallpaperBrowserState>((
      ref,
    ) {
      final browseWallpapersUseCase = ref.watch(
        browseWallpapersUseCaseProvider,
      );
      return WallpaperBrowserNotifier(browseWallpapersUseCase);
    });
