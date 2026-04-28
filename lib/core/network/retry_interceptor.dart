import 'dart:io';
import 'package:dio/dio.dart';

/// Interceptor that retries failed requests with exponential backoff
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration initialDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(milliseconds: 500),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only retry on specific error types
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    // Get retry count from request extra data
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    // Check if we've exceeded max retries
    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    // Calculate delay with exponential backoff
    final delay = _calculateDelay(retryCount);

    // Wait before retrying
    await Future.delayed(delay);

    // Increment retry count
    err.requestOptions.extra['retryCount'] = retryCount + 1;

    try {
      // Retry the request
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Determine if the error should trigger a retry
  bool _shouldRetry(DioException error) {
    // Don't retry on cancel
    if (error.type == DioExceptionType.cancel) {
      return false;
    }

    // Retry on timeout
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return true;
    }

    // Retry on connection errors (no internet, DNS failure, etc.)
    if (error.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on specific HTTP status codes
    if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        // Retry on server errors (5xx) and rate limiting (429)
        return statusCode >= 500 || statusCode == 429;
      }
    }

    // Retry on socket exceptions
    if (error.error is SocketException) {
      return true;
    }

    return false;
  }

  /// Calculate delay with exponential backoff
  Duration _calculateDelay(int retryCount) {
    // Exponential backoff: initialDelay * 2^retryCount
    final multiplier = 1 << retryCount; // 2^retryCount
    return initialDelay * multiplier;
  }
}
