import '../repositories/cache_repository.dart';

/// Use case for getting cache size
/// Requirements: 7.5
class GetCacheSizeUseCase {
  final CacheRepository _repository;

  GetCacheSizeUseCase(this._repository);

  /// Execute the use case
  ///
  /// Returns cache size in bytes
  Future<int> execute() async {
    return await _repository.getCacheSize();
  }
}
