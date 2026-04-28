import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for getting a wallpaper by its ID
/// Requirements: 1.1, 1.2, 1.3, 1.4
class GetWallpaperByIdUseCase {
  final WallpaperRepository _repository;

  const GetWallpaperByIdUseCase(this._repository);

  /// Execute the use case to get a wallpaper by ID
  ///
  /// [id] - Wallpaper unique identifier
  ///
  /// Returns wallpaper entity
  Future<Wallpaper> execute(String id) async {
    return await _repository.getWallpaperById(id);
  }
}
