import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/cache_domain_providers.dart';
import '../notifiers/cache_manager_notifier.dart';

/// Provider for CacheManagerNotifier
/// Requirements: 7.5
final cacheManagerNotifierProvider =
    StateNotifierProvider<CacheManagerNotifier, CacheManagerState>((ref) {
      final getCacheSizeUseCase = ref.watch(getCacheSizeUseCaseProvider);
      final clearCacheUseCase = ref.watch(clearCacheUseCaseProvider);
      return CacheManagerNotifier(getCacheSizeUseCase, clearCacheUseCase);
    });
