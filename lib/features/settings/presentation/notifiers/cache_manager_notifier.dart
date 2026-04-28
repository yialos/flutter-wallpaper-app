import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../settings/domain/usecases/clear_cache_use_case.dart';
import '../../../settings/domain/usecases/get_cache_size_use_case.dart';

/// State class for cache management
/// Requirements: 7.5
class CacheManagerState {
  final int cacheSize;
  final bool isLoading;
  final String? error;

  const CacheManagerState({
    this.cacheSize = 0,
    this.isLoading = false,
    this.error,
  });

  CacheManagerState copyWith({
    int? cacheSize,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CacheManagerState(
      cacheSize: cacheSize ?? this.cacheSize,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// State notifier for cache management
/// Requirements: 7.5
class CacheManagerNotifier extends StateNotifier<CacheManagerState> {
  final GetCacheSizeUseCase _getCacheSizeUseCase;
  final ClearCacheUseCase _clearCacheUseCase;

  CacheManagerNotifier(this._getCacheSizeUseCase, this._clearCacheUseCase)
    : super(const CacheManagerState());

  /// Load cache size
  /// Requirements: 7.5
  Future<void> loadCacheSize() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final size = await _getCacheSizeUseCase.execute();

      state = state.copyWith(cacheSize: size, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Clear cache
  /// Requirements: 7.5
  Future<void> clearCache() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _clearCacheUseCase.execute();

      state = state.copyWith(cacheSize: 0, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Clear any error state
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
