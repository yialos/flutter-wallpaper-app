import '../repositories/cache_repository.dart';

/// Use case for clearing cache
/// Requirements: 7.5
class ClearCacheUseCase {
  final CacheRepository _repository;

  ClearCacheUseCase(this._repository);

  /// Execute the use case
  ///
  /// Clears all cached data
  Future<void> execute() async {
    await _repository.clearCache();
  }
}
