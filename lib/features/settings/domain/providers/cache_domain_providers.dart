import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/cache_providers.dart';
import '../usecases/get_cache_size_use_case.dart';
import '../usecases/clear_cache_use_case.dart';

/// Provider for GetCacheSizeUseCase
/// Requirements: 7.5
final getCacheSizeUseCaseProvider = Provider<GetCacheSizeUseCase>((ref) {
  final repository = ref.watch(cacheRepositoryProvider);
  return GetCacheSizeUseCase(repository);
});

/// Provider for ClearCacheUseCase
/// Requirements: 7.5
final clearCacheUseCaseProvider = Provider<ClearCacheUseCase>((ref) {
  final repository = ref.watch(cacheRepositoryProvider);
  return ClearCacheUseCase(repository);
});
