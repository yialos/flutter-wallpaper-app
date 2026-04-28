import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/wallpaper_setter_repository_impl.dart';
import '../services/wallpaper_setter_service.dart';
import '../../domain/repositories/wallpaper_setter_repository.dart';

/// Provider for WallpaperSetterService
/// Requirements: 5.1, 5.2, 5.3
final wallpaperSetterServiceProvider = Provider<WallpaperSetterService>((ref) {
  return WallpaperSetterFactory.create();
});

/// Provider for WallpaperSetterRepository
/// Requirements: 5.1, 5.2, 5.3
final wallpaperSetterRepositoryProvider = Provider<WallpaperSetterRepository>((
  ref,
) {
  final service = ref.watch(wallpaperSetterServiceProvider);
  return WallpaperSetterRepositoryImpl(service: service);
});
