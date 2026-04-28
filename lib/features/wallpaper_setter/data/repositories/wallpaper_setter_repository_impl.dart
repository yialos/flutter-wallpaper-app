import 'dart:io';
import '../../domain/entities/wallpaper_target.dart';
import '../../domain/repositories/wallpaper_setter_repository.dart';
import '../services/wallpaper_setter_service.dart';

/// Implementation of WallpaperSetterRepository
/// Requirements: 5.1, 5.2, 5.3
class WallpaperSetterRepositoryImpl implements WallpaperSetterRepository {
  final WallpaperSetterService _service;

  WallpaperSetterRepositoryImpl({required WallpaperSetterService service})
    : _service = service;

  @override
  Future<bool> setWallpaper(File imageFile, WallpaperTarget target) async {
    return await _service.setWallpaper(imageFile, target);
  }

  @override
  bool isSupported() {
    return _service.isSupported();
  }

  @override
  List<WallpaperTarget> getSupportedTargets() {
    return _service.getSupportedTargets();
  }
}
