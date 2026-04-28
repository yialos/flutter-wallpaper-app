import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../browse/data/providers/browse_providers.dart';
import '../../domain/repositories/search_repository.dart';
import '../repositories/search_repository_impl.dart';

/// Provider for SearchRepository
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final remoteDataSource = ref.watch(wallpaperRemoteDataSourceProvider);
  return SearchRepositoryImpl(remoteDataSource: remoteDataSource);
});
