import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/core/config/app_config.dart';

/// Provider for application configuration
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.current();
});

/// Provider for API base URL
final apiBaseUrlProvider = Provider<String>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.apiBaseUrl;
});

/// Provider for API timeout
final apiTimeoutProvider = Provider<Duration>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.apiTimeout;
});

/// Provider for max retries
final maxRetriesProvider = Provider<int>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.maxRetries;
});
