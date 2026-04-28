/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final dynamic details;

  const AppException(this.message, [this.details]);

  @override
  String toString() =>
      'AppException: $message${details != null ? ' ($details)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  final NetworkErrorType type;
  final int? statusCode;

  const NetworkException(
    this.type,
    String message, [
    this.statusCode,
    dynamic details,
  ]) : super(message, details);

  @override
  String toString() =>
      'NetworkException: $type - $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

enum NetworkErrorType {
  noConnection,
  timeout,
  serverError,
  unauthorized,
  notFound,
  badRequest,
  unknown,
}

/// Download-related exceptions
class DownloadException extends AppException {
  final DownloadErrorType type;

  const DownloadException(this.type, String message, [dynamic details])
    : super(message, details);

  @override
  String toString() => 'DownloadException: $type - $message';
}

enum DownloadErrorType {
  insufficientStorage,
  permissionDenied,
  networkError,
  fileCorrupted,
  unknown,
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException(super.message, [super.details]);

  @override
  String toString() => 'CacheException: $message';
}

/// Platform-specific exceptions
class PlatformException extends AppException {
  final String code;

  const PlatformException(this.code, String message, [dynamic details])
    : super(message, details);

  @override
  String toString() => 'PlatformException: $code - $message';
}
