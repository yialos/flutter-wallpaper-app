import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/share_repository_impl.dart';
import '../../data/services/share_service.dart';
import '../../domain/repositories/share_repository.dart';
import '../../domain/usecases/share_wallpaper_use_case.dart';

/// Provider for ShareService
final shareServiceProvider = Provider<ShareService>((ref) {
  return ShareService();
});

/// Provider for ShareRepository
final shareRepositoryProvider = Provider<ShareRepository>((ref) {
  final shareService = ref.watch(shareServiceProvider);
  return ShareRepositoryImpl(shareService: shareService);
});

/// Provider for ShareWallpaperUseCase
final shareWallpaperUseCaseProvider = Provider<ShareWallpaperUseCase>((ref) {
  final repository = ref.watch(shareRepositoryProvider);
  return ShareWallpaperUseCase(repository);
});
