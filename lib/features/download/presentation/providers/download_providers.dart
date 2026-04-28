import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/download_manager.dart';
import '../../domain/repositories/download_repository.dart';
import '../../data/repositories/download_repository_impl.dart';
import '../../domain/usecases/download_wallpaper_use_case.dart';

/// Provider for DownloadManager
/// Requirements: 4.2, 4.3
final downloadManagerProvider = Provider<DownloadManager>((ref) {
  return DownloadManager();
});

/// Provider for DownloadRepository
/// Requirements: 4.1, 4.2
final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  final downloadManager = ref.watch(downloadManagerProvider);
  return DownloadRepositoryImpl(downloadManager: downloadManager);
});

/// Provider for DownloadWallpaperUseCase
/// Requirements: 4.1, 4.2, 4.3, 4.4, 4.5
final downloadWallpaperUseCaseProvider = Provider<DownloadWallpaperUseCase>((
  ref,
) {
  final repository = ref.watch(downloadRepositoryProvider);
  return DownloadWallpaperUseCase(repository);
});
