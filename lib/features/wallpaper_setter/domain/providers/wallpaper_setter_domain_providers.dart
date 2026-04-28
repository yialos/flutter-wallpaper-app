import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/wallpaper_setter_providers.dart';
import '../usecases/set_wallpaper_use_case.dart';

/// Provider for SetWallpaperUseCase
/// Requirements: 5.1, 5.2, 5.3
final setWallpaperUseCaseProvider = Provider<SetWallpaperUseCase>((ref) {
  final repository = ref.watch(wallpaperSetterRepositoryProvider);
  return SetWallpaperUseCase(repository);
});
