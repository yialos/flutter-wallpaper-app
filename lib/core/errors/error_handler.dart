import 'package:wallpaper_app/core/constants/app_strings.dart';
import 'exceptions.dart';

/// Centralized error handler
class ErrorHandler {
  /// Get user-friendly error message
  static String getUserMessage(Exception error) {
    if (error is NetworkException) {
      return _getNetworkErrorMessage(error);
    } else if (error is DownloadException) {
      return _getDownloadErrorMessage(error);
    } else if (error is CacheException) {
      return AppStrings.errorGeneric;
    } else if (error is PlatformException) {
      return _getPlatformErrorMessage(error);
    } else {
      return AppStrings.errorGeneric;
    }
  }

  static String _getNetworkErrorMessage(NetworkException error) {
    switch (error.type) {
      case NetworkErrorType.noConnection:
        return AppStrings.noConnection;
      case NetworkErrorType.timeout:
        return AppStrings.errorTimeout;
      case NetworkErrorType.serverError:
        return AppStrings.errorServer;
      case NetworkErrorType.unauthorized:
        return 'Không có quyền truy cập';
      case NetworkErrorType.notFound:
        return 'Không tìm thấy tài nguyên';
      case NetworkErrorType.badRequest:
        return 'Yêu cầu không hợp lệ';
      default:
        return AppStrings.errorNetwork;
    }
  }

  static String _getDownloadErrorMessage(DownloadException error) {
    switch (error.type) {
      case DownloadErrorType.insufficientStorage:
        return AppStrings.errorStorage;
      case DownloadErrorType.permissionDenied:
        return AppStrings.errorPermission;
      case DownloadErrorType.networkError:
        return AppStrings.errorNetwork;
      case DownloadErrorType.fileCorrupted:
        return 'Tệp bị hỏng';
      default:
        return AppStrings.downloadError;
    }
  }

  static String _getPlatformErrorMessage(PlatformException error) {
    switch (error.code) {
      case 'PERMISSION_DENIED':
        return AppStrings.errorPermission;
      case 'NOT_SUPPORTED':
        return 'Thiết bị không hỗ trợ tính năng này';
      default:
        return AppStrings.errorGeneric;
    }
  }
}
