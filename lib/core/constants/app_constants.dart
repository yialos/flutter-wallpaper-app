/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://api.wallpaperapp.com/v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Cache Configuration
  static const int maxCacheSizeBytes = 500 * 1024 * 1024; // 500 MB
  static const Duration maxCacheAge = Duration(days: 30);

  // Image Configuration
  static const int thumbnailQuality = 80;
  static const int fullImageQuality = 95;

  // UI Configuration
  static const int gridCrossAxisCount = 2;
  static const double gridSpacing = 8.0;
  static const double gridAspectRatio = 0.7;

  // Debounce
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);

  // Performance
  static const int targetFrameRate = 60;
  static const Duration launchTimeTarget = Duration(seconds: 3);

  // Storage Keys
  static const String favoritesBoxName = 'favorites';
  static const String cacheMetadataBoxName = 'cache_metadata';
  static const String settingsBoxName = 'settings';
}
