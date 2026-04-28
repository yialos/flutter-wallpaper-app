import 'package:flutter/foundation.dart';
import '../utils/edge_case_handler.dart';

/// Centralized error handler for the application
/// Requirements: 8.1, 8.2, 11.1, 11.2, 11.3
class AppErrorHandler {
  AppErrorHandler._();

  /// Handle error and return user-friendly message
  static String handleError(dynamic error, {StackTrace? stackTrace}) {
    // Log error in debug mode
    if (kDebugMode) {
      debugPrint('Error: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }

    // Get user-friendly message
    return EdgeCaseHandler.getUserFriendlyErrorMessage(error);
  }

  /// Check if error should show retry button
  static bool shouldShowRetry(dynamic error) {
    return EdgeCaseHandler.isRecoverableError(error);
  }

  /// Handle network errors specifically
  static String handleNetworkError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('socket') ||
        errorString.contains('failed host lookup')) {
      return 'Không thể kết nối đến máy chủ. '
          'Vui lòng kiểm tra kết nối internet.';
    }

    if (errorString.contains('timeout')) {
      return 'Kết nối quá chậm. Vui lòng thử lại sau.';
    }

    if (errorString.contains('certificate') ||
        errorString.contains('handshake')) {
      return 'Lỗi bảo mật kết nối. Vui lòng kiểm tra cài đặt mạng.';
    }

    return 'Lỗi kết nối mạng. Vui lòng thử lại.';
  }

  /// Handle storage errors
  static String handleStorageError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('space') || errorString.contains('full')) {
      return 'Không đủ dung lượng lưu trữ. '
          'Vui lòng giải phóng bộ nhớ và thử lại.';
    }

    if (errorString.contains('permission')) {
      return EdgeCaseHandler.getPermissionDeniedMessage('storage');
    }

    if (errorString.contains('not found') || errorString.contains('path')) {
      return 'Không thể truy cập bộ nhớ. Vui lòng thử lại.';
    }

    return 'Lỗi lưu trữ. Vui lòng thử lại.';
  }

  /// Handle cache errors
  static String handleCacheError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('corrupt') || errorString.contains('invalid')) {
      return 'Dữ liệu cache bị lỗi. Đang xóa cache...';
    }

    return 'Lỗi cache. Vui lòng xóa cache trong cài đặt.';
  }

  /// Handle permission errors
  static String handlePermissionError(String permission) {
    return EdgeCaseHandler.getPermissionDeniedMessage(permission);
  }

  /// Handle API errors
  static String handleApiError(int? statusCode, {String? message}) {
    if (statusCode == null) {
      return 'Lỗi kết nối API. Vui lòng thử lại.';
    }

    switch (statusCode) {
      case 400:
        return 'Yêu cầu không hợp lệ. Vui lòng thử lại.';
      case 401:
        return 'Không có quyền truy cập. Vui lòng đăng nhập lại.';
      case 403:
        return 'Truy cập bị từ chối. Vui lòng kiểm tra quyền.';
      case 404:
        return 'Không tìm thấy dữ liệu. Vui lòng thử lại.';
      case 429:
        return 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
      case 500:
      case 502:
      case 503:
        return 'Lỗi máy chủ. Vui lòng thử lại sau.';
      case 504:
        return 'Máy chủ không phản hồi. Vui lòng thử lại.';
      default:
        return message ?? 'Lỗi không xác định. Vui lòng thử lại.';
    }
  }

  /// Handle race conditions
  static Future<T> handleRaceCondition<T>({
    required Future<T> Function() operation,
    required String operationName,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      return await operation().timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException(
            'Thao tác $operationName mất quá nhiều thời gian',
          );
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Race condition in $operationName: $e');
      }
      rethrow;
    }
  }

  /// Prevent memory leaks by canceling operations
  static void cancelOperation(dynamic operation) {
    if (operation is Future) {
      // Futures can't be canceled, but we can ignore their results
      operation.ignore();
    }
  }
}

/// Custom timeout exception
class TimeoutException implements Exception {
  final String message;

  TimeoutException(this.message);

  @override
  String toString() => message;
}
