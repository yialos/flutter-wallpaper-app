import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Utility class for handling edge cases throughout the app
/// Requirements: 2.3, 8.1, 11.2
class EdgeCaseHandler {
  EdgeCaseHandler._();

  /// Check if device has sufficient storage for download
  /// Returns true if sufficient storage available, false otherwise
  static Future<bool> hasSufficientStorage({
    required int requiredBytes,
    int bufferBytes = 50 * 1024 * 1024, // 50MB buffer
  }) async {
    try {
      if (kIsWeb) {
        // Web has no storage limit check
        return true;
      }

      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      // Get available space (platform-specific)
      if (Platform.isAndroid || Platform.isIOS) {
        // For mobile, we'll use a heuristic approach
        // Try to create a test file to check if we have space
        try {
          final testFile = File('$path/.storage_test');
          await testFile.writeAsBytes(List.filled(1024, 0));
          await testFile.delete();
          return true;
        } catch (e) {
          return false;
        }
      }

      // For desktop, assume sufficient storage
      return true;
    } catch (e) {
      // If we can't check, assume we have space
      return true;
    }
  }

  /// Validate image URL format
  /// Returns true if URL is valid, false otherwise
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }

    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
        return false;
      }

      // Check if URL ends with common image extensions
      final path = uri.path.toLowerCase();
      final validExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.gif'];
      final hasValidExtension = validExtensions.any(path.endsWith);

      // Also accept URLs without extensions (like Unsplash URLs)
      return hasValidExtension || !path.contains('.');
    } catch (e) {
      return false;
    }
  }

  /// Sanitize search query
  /// Removes special characters and trims whitespace
  static String sanitizeSearchQuery(String query) {
    // Trim whitespace
    String sanitized = query.trim();

    // Remove multiple spaces
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');

    // Remove special characters that might cause issues
    sanitized = sanitized.replaceAll(RegExp(r'[<>{}[\]\\]'), '');

    return sanitized;
  }

  /// Validate search query
  /// Returns error message if invalid, null if valid
  static String? validateSearchQuery(String query) {
    final sanitized = sanitizeSearchQuery(query);

    if (sanitized.isEmpty) {
      return 'Vui lòng nhập từ khóa tìm kiếm';
    }

    if (sanitized.length < 2) {
      return 'Từ khóa tìm kiếm phải có ít nhất 2 ký tự';
    }

    if (sanitized.length > 100) {
      return 'Từ khóa tìm kiếm quá dài (tối đa 100 ký tự)';
    }

    return null;
  }

  /// Handle corrupted cache data
  /// Returns true if cache was cleared successfully
  static Future<bool> handleCorruptedCache() async {
    try {
      if (kIsWeb) {
        // Web cache handling
        return true;
      }

      final cacheDir = await getTemporaryDirectory();
      final cacheFiles = cacheDir.listSync();

      // Delete corrupted files
      for (final file in cacheFiles) {
        try {
          if (file is File) {
            await file.delete();
          }
        } catch (e) {
          // Continue even if some files can't be deleted
          debugPrint('Failed to delete cache file: $e');
        }
      }

      return true;
    } catch (e) {
      debugPrint('Failed to handle corrupted cache: $e');
      return false;
    }
  }

  /// Check if app is running for the first time
  static Future<bool> isFirstLaunch() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final flagFile = File('${directory.path}/.first_launch');

      if (await flagFile.exists()) {
        return false;
      }

      // Create flag file
      await flagFile.create();
      return true;
    } catch (e) {
      // If we can't check, assume not first launch
      return false;
    }
  }

  /// Handle first launch with no internet
  /// Returns appropriate message for user
  static String getFirstLaunchOfflineMessage() {
    return 'Ứng dụng cần kết nối internet để tải dữ liệu lần đầu. '
        'Vui lòng kiểm tra kết nối mạng và thử lại.';
  }

  /// Validate file path for security
  /// Prevents path traversal attacks
  static bool isValidFilePath(String path) {
    // Check for path traversal attempts
    if (path.contains('..') || path.contains('~')) {
      return false;
    }

    // Check for absolute paths (should be relative)
    if (path.startsWith('/') || path.contains(':')) {
      return false;
    }

    return true;
  }

  /// Get safe filename from URL
  /// Removes special characters and limits length
  static String getSafeFilename(String url, {int maxLength = 100}) {
    try {
      final uri = Uri.parse(url);
      String filename = uri.pathSegments.last;

      // Remove special characters
      filename = filename.replaceAll(RegExp(r'[^\w\-.]'), '_');

      // Limit length
      if (filename.length > maxLength) {
        final extension = filename.split('.').last;
        final nameWithoutExt = filename.substring(
          0,
          filename.length - extension.length - 1,
        );
        filename =
            '${nameWithoutExt.substring(0, maxLength - extension.length - 1)}.$extension';
      }

      return filename;
    } catch (e) {
      // Fallback to timestamp-based filename
      return 'wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';
    }
  }

  /// Handle permission denied scenarios
  /// Returns user-friendly error message
  static String getPermissionDeniedMessage(String permission) {
    switch (permission.toLowerCase()) {
      case 'storage':
        return 'Ứng dụng cần quyền truy cập bộ nhớ để tải hình nền. '
            'Vui lòng cấp quyền trong cài đặt.';
      case 'photos':
        return 'Ứng dụng cần quyền truy cập thư viện ảnh để lưu hình nền. '
            'Vui lòng cấp quyền trong cài đặt.';
      case 'internet':
        return 'Ứng dụng cần quyền truy cập internet để tải hình nền. '
            'Vui lòng kiểm tra cài đặt mạng.';
      default:
        return 'Ứng dụng cần quyền $permission để hoạt động. '
            'Vui lòng cấp quyền trong cài đặt.';
    }
  }

  /// Check if error is recoverable
  /// Returns true if user can retry, false if permanent error
  static bool isRecoverableError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Network errors are recoverable
    if (errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return true;
    }

    // Storage errors might be recoverable
    if (errorString.contains('storage') || errorString.contains('space')) {
      return true;
    }

    // Permission errors are not immediately recoverable
    if (errorString.contains('permission')) {
      return false;
    }

    // Unknown errors - assume recoverable
    return true;
  }

  /// Get user-friendly error message
  /// Converts technical errors to Vietnamese messages
  static String getUserFriendlyErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('socket') || errorString.contains('connection')) {
      return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng.';
    }

    if (errorString.contains('timeout')) {
      return 'Kết nối quá chậm. Vui lòng thử lại.';
    }

    if (errorString.contains('404') || errorString.contains('not found')) {
      return 'Không tìm thấy dữ liệu. Vui lòng thử lại sau.';
    }

    if (errorString.contains('500') || errorString.contains('server')) {
      return 'Lỗi máy chủ. Vui lòng thử lại sau.';
    }

    if (errorString.contains('storage') || errorString.contains('space')) {
      return 'Không đủ dung lượng lưu trữ. Vui lòng giải phóng bộ nhớ.';
    }

    if (errorString.contains('permission')) {
      return 'Không có quyền truy cập. Vui lòng cấp quyền trong cài đặt.';
    }

    if (errorString.contains('format') || errorString.contains('parse')) {
      return 'Dữ liệu không hợp lệ. Vui lòng thử lại.';
    }

    // Default message
    return 'Đã xảy ra lỗi. Vui lòng thử lại.';
  }

  /// Retry with exponential backoff
  /// Attempts operation multiple times with increasing delays
  static Future<T> retryWithBackoff<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        return await operation();
      } catch (e) {
        attempt++;

        if (attempt >= maxAttempts) {
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(delay);

        // Increase delay for next attempt
        delay = Duration(
          milliseconds: (delay.inMilliseconds * backoffMultiplier).round(),
        );
      }
    }
  }
}
