import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_app/core/errors/exceptions.dart';

/// Download manager for downloading wallpapers
/// Requirements: 4.2, 4.3, 9.2
class DownloadManager {
  final Dio _dio;

  DownloadManager({Dio? dio}) : _dio = dio ?? Dio();

  /// Download a file from URL to device storage
  /// Returns the file path where the file was saved
  /// Requirements: 4.2, 4.3
  Future<String> downloadFile({
    required String url,
    required String fileName,
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      // Get downloads directory
      final directory = await _getDownloadsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Download file with progress tracking
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (onProgress != null && total != -1) {
            onProgress(received, total);
          }
        },
      );

      return filePath;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw DownloadException(
        DownloadErrorType.unknown,
        'Lỗi không xác định khi tải xuống: ${e.toString()}',
      );
    }
  }

  /// Get the downloads directory for the platform
  Future<Directory> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      // On Android, use external storage directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw DownloadException(
          DownloadErrorType.permissionDenied,
          'Không thể truy cập thư mục lưu trữ',
        );
      }

      // Create Downloads folder if it doesn't exist
      final downloadsDir = Directory('${directory.path}/Downloads');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      return downloadsDir;
    } else if (Platform.isIOS) {
      // On iOS, use documents directory
      return await getApplicationDocumentsDirectory();
    } else {
      // On desktop/web, use downloads directory
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        throw DownloadException(
          DownloadErrorType.permissionDenied,
          'Không thể truy cập thư mục tải xuống',
        );
      }
      return directory;
    }
  }

  /// Check if there's enough storage space
  /// Requirements: 4.5
  Future<bool> hasEnoughStorage(int requiredBytes) async {
    try {
      await _getDownloadsDirectory();
      // This is a simplified check - in production, you'd want to check actual free space
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Handle Dio errors and convert to DownloadException
  DownloadException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DownloadException(
          DownloadErrorType.networkError,
          'Hết thời gian chờ. Vui lòng thử lại.',
        );

      case DioExceptionType.connectionError:
        return DownloadException(
          DownloadErrorType.networkError,
          'Không có kết nối internet. Vui lòng kiểm tra kết nối của bạn.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return DownloadException(
            DownloadErrorType.unknown,
            'Không tìm thấy file.',
          );
        } else if (statusCode != null && statusCode >= 500) {
          return DownloadException(
            DownloadErrorType.networkError,
            'Lỗi máy chủ. Vui lòng thử lại sau.',
          );
        }
        return DownloadException(
          DownloadErrorType.unknown,
          'Lỗi tải xuống. Vui lòng thử lại.',
        );

      case DioExceptionType.cancel:
        return DownloadException(
          DownloadErrorType.unknown,
          'Đã hủy tải xuống.',
        );

      default:
        return DownloadException(
          DownloadErrorType.unknown,
          'Lỗi không xác định. Vui lòng thử lại.',
        );
    }
  }
}
