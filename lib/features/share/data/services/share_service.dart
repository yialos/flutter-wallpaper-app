import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:wallpaper_app/features/browse/domain/entities/wallpaper.dart';

/// Service for sharing wallpapers
/// Supports sharing via social media, email, messaging apps
class ShareService {
  /// Share wallpaper with text and optional image file
  ///
  /// [wallpaper] - The wallpaper to share
  /// [imagePath] - Optional local path to downloaded image
  Future<ShareResult> shareWallpaper({
    required Wallpaper wallpaper,
    String? imagePath,
  }) async {
    try {
      final String text = _buildShareText(wallpaper);

      // If image is downloaded, share with image
      if (imagePath != null && await File(imagePath).exists()) {
        return await Share.shareXFiles(
          [XFile(imagePath)],
          text: text,
          subject: 'Hình nền đẹp - ${wallpaper.title}',
        );
      }

      // Otherwise, share text with link only
      return await Share.shareXFiles(
        [],
        text: text,
        subject: 'Hình nền đẹp - ${wallpaper.title}',
      );
    } catch (e) {
      throw ShareException('Không thể chia sẻ: ${e.toString()}');
    }
  }

  /// Share wallpaper URL only (no image file)
  Future<ShareResult> shareWallpaperLink({required Wallpaper wallpaper}) async {
    try {
      final String text = _buildShareText(wallpaper);
      return await Share.shareXFiles(
        [],
        text: text,
        subject: 'Hình nền đẹp - ${wallpaper.title}',
      );
    } catch (e) {
      throw ShareException('Không thể chia sẻ: ${e.toString()}');
    }
  }

  /// Share multiple wallpapers
  Future<ShareResult> shareMultipleWallpapers({
    required List<Wallpaper> wallpapers,
    List<String>? imagePaths,
  }) async {
    try {
      if (imagePaths != null && imagePaths.isNotEmpty) {
        // Share with images
        final xFiles = imagePaths
            .where((path) => File(path).existsSync())
            .map((path) => XFile(path))
            .toList();

        if (xFiles.isNotEmpty) {
          return await Share.shareXFiles(
            xFiles,
            text: 'Chia sẻ ${wallpapers.length} hình nền đẹp',
            subject: 'Bộ sưu tập hình nền',
          );
        }
      }

      // Share text only
      final text = wallpapers
          .map((w) => '${w.title}\n${w.fullResolutionUrl}')
          .join('\n\n---\n\n');

      return await Share.shareXFiles(
        [],
        text: text,
        subject: 'Bộ sưu tập hình nền (${wallpapers.length} hình)',
      );
    } catch (e) {
      throw ShareException('Không thể chia sẻ: ${e.toString()}');
    }
  }

  /// Build share text with wallpaper info
  String _buildShareText(Wallpaper wallpaper) {
    final buffer = StringBuffer();

    buffer.writeln('🖼️ ${wallpaper.title}');

    if (wallpaper.author != null && wallpaper.author!.isNotEmpty) {
      buffer.writeln('📸 Tác giả: ${wallpaper.author}');
    }

    buffer.writeln(
      '📐 Độ phân giải: ${wallpaper.resolution.width}x${wallpaper.resolution.height}',
    );

    if (wallpaper.categories.isNotEmpty) {
      buffer.writeln('🏷️ Danh mục: ${wallpaper.categories.join(", ")}');
    }

    buffer.writeln();
    buffer.writeln('🔗 Link: ${wallpaper.fullResolutionUrl}');
    buffer.writeln();
    buffer.writeln('📱 Tải app Wallpaper để xem thêm hình nền đẹp!');

    return buffer.toString();
  }
}

/// Exception thrown when sharing fails
class ShareException implements Exception {
  final String message;

  ShareException(this.message);

  @override
  String toString() => message;
}
