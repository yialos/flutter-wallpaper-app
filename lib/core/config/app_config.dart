import 'package:flutter/foundation.dart';

/// Application configuration
///
/// NOTE: Currently using mock data in WallpaperRemoteDataSourceImpl
/// To use real Unsplash API, update the implementation in:
/// lib/features/browse/data/datasources/wallpaper_remote_datasource.dart
class AppConfig {
  final String apiBaseUrl;
  final Duration apiTimeout;
  final int maxRetries;
  final bool enableLogging;
  final bool enableAnalytics;

  const AppConfig({
    required this.apiBaseUrl,
    required this.apiTimeout,
    required this.maxRetries,
    required this.enableLogging,
    required this.enableAnalytics,
  });

  /// Development configuration
  factory AppConfig.development() {
    return const AppConfig(
      apiBaseUrl: 'https://api.unsplash.com',
      apiTimeout: Duration(seconds: 30),
      maxRetries: 3,
      enableLogging: true,
      enableAnalytics: false,
    );
  }

  /// Production configuration
  factory AppConfig.production() {
    return const AppConfig(
      apiBaseUrl: 'https://api.unsplash.com',
      apiTimeout: Duration(seconds: 30),
      maxRetries: 3,
      enableLogging: false,
      enableAnalytics: true,
    );
  }

  /// Get current configuration based on build mode
  factory AppConfig.current() {
    return kDebugMode ? AppConfig.development() : AppConfig.production();
  }
}
