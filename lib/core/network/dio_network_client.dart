import 'dart:io';
import 'package:dio/dio.dart';
import 'package:wallpaper_app/core/config/app_config.dart';
import 'package:wallpaper_app/core/errors/exceptions.dart';
import 'network_client.dart';
import 'retry_interceptor.dart';

/// Dio implementation of NetworkClient
class DioNetworkClient implements NetworkClient {
  final Dio _dio;
  final AppConfig _config;

  DioNetworkClient({required AppConfig config})
    : _config = config,
      _dio = Dio() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _config.apiBaseUrl,
      connectTimeout: _config.apiTimeout,
      receiveTimeout: _config.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add retry interceptor
    _dio.interceptors.add(
      RetryInterceptor(dio: _dio, maxRetries: _config.maxRetries),
    );

    // Add logging interceptor in debug mode
    if (_config.enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, error: true),
      );
    }
  }

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Response> download(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Convert DioException to app-specific exceptions
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          NetworkErrorType.timeout,
          'Yêu cầu hết thời gian chờ',
          null,
          error,
        );

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return NetworkException(
            NetworkErrorType.noConnection,
            'Không có kết nối internet',
            null,
            error,
          );
        }
        return NetworkException(
          NetworkErrorType.unknown,
          'Lỗi kết nối',
          null,
          error,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            return NetworkException(
              NetworkErrorType.serverError,
              'Lỗi máy chủ',
              statusCode,
              error,
            );
          } else if (statusCode == 401) {
            return NetworkException(
              NetworkErrorType.unauthorized,
              'Không có quyền truy cập',
              statusCode,
              error,
            );
          } else if (statusCode == 404) {
            return NetworkException(
              NetworkErrorType.notFound,
              'Không tìm thấy tài nguyên',
              statusCode,
              error,
            );
          } else if (statusCode >= 400) {
            return NetworkException(
              NetworkErrorType.badRequest,
              'Yêu cầu không hợp lệ',
              statusCode,
              error,
            );
          }
        }
        return NetworkException(
          NetworkErrorType.serverError,
          'Lỗi phản hồi từ máy chủ',
          statusCode,
          error,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          NetworkErrorType.unknown,
          'Yêu cầu đã bị hủy',
          null,
          error,
        );

      default:
        return NetworkException(
          NetworkErrorType.unknown,
          'Lỗi không xác định',
          null,
          error,
        );
    }
  }
}
