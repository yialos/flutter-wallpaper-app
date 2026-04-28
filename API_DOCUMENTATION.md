# API Documentation

## Overview
This document provides comprehensive documentation for the Wallpaper App's public APIs and key components.

## Table of Contents
- [Core Utilities](#core-utilities)
- [State Management](#state-management)
- [Data Layer](#data-layer)
- [Domain Layer](#domain-layer)
- [Presentation Layer](#presentation-layer)
- [Error Handling](#error-handling)

---

## Core Utilities

### EdgeCaseHandler
Utility class for handling edge cases throughout the app.

#### Methods

##### `hasSufficientStorage`
```dart
static Future<bool> hasSufficientStorage({
  required int requiredBytes,
  int bufferBytes = 50 * 1024 * 1024,
})
```
Checks if device has sufficient storage for download.

**Parameters:**
- `requiredBytes`: Required storage in bytes
- `bufferBytes`: Safety buffer (default: 50MB)

**Returns:** `true` if sufficient storage available

**Example:**
```dart
final hasSpace = await EdgeCaseHandler.hasSufficientStorage(
  requiredBytes: 10 * 1024 * 1024, // 10MB
);
```

##### `isValidImageUrl`
```dart
static bool isValidImageUrl(String? url)
```
Validates image URL format.

**Parameters:**
- `url`: URL to validate

**Returns:** `true` if URL is valid

**Example:**
```dart
if (EdgeCaseHandler.isValidImageUrl(imageUrl)) {
  // Proceed with download
}
```

##### `sanitizeSearchQuery`
```dart
static String sanitizeSearchQuery(String query)
```
Removes special characters and trims whitespace from search query.

**Parameters:**
- `query`: Raw search query

**Returns:** Sanitized query string

**Example:**
```dart
final clean = EdgeCaseHandler.sanitizeSearchQuery('  hello<>world  ');
// Returns: "hello world"
```

##### `validateSearchQuery`
```dart
static String? validateSearchQuery(String query)
```
Validates search query length and format.

**Parameters:**
- `query`: Search query to validate

**Returns:** Error message if invalid, `null` if valid

**Example:**
```dart
final error = EdgeCaseHandler.validateSearchQuery('a');
if (error != null) {
  print(error); // "Từ khóa tìm kiếm phải có ít nhất 2 ký tự"
}
```

##### `retryWithBackoff`
```dart
static Future<T> retryWithBackoff<T>({
  required Future<T> Function() operation,
  int maxAttempts = 3,
  Duration initialDelay = const Duration(seconds: 1),
  double backoffMultiplier = 2.0,
})
```
Retries operation with exponential backoff.

**Parameters:**
- `operation`: Async operation to retry
- `maxAttempts`: Maximum retry attempts (default: 3)
- `initialDelay`: Initial delay between retries (default: 1s)
- `backoffMultiplier`: Delay multiplier (default: 2.0)

**Returns:** Result of successful operation

**Throws:** Last error if all attempts fail

**Example:**
```dart
final result = await EdgeCaseHandler.retryWithBackoff(
  operation: () => api.fetchData(),
  maxAttempts: 3,
);
```

---

### AppErrorHandler
Centralized error handler for the application.

#### Methods

##### `handleError`
```dart
static String handleError(dynamic error, {StackTrace? stackTrace})
```
Handles error and returns user-friendly message.

**Parameters:**
- `error`: Error object
- `stackTrace`: Optional stack trace

**Returns:** User-friendly error message in Vietnamese

**Example:**
```dart
try {
  await downloadFile();
} catch (e, stackTrace) {
  final message = AppErrorHandler.handleError(e, stackTrace: stackTrace);
  showSnackBar(message);
}
```

##### `shouldShowRetry`
```dart
static bool shouldShowRetry(dynamic error)
```
Determines if error is recoverable and retry button should be shown.

**Parameters:**
- `error`: Error object

**Returns:** `true` if error is recoverable

**Example:**
```dart
if (AppErrorHandler.shouldShowRetry(error)) {
  showRetryButton();
}
```

##### `handleApiError`
```dart
static String handleApiError(int? statusCode, {String? message})
```
Handles HTTP API errors.

**Parameters:**
- `statusCode`: HTTP status code
- `message`: Optional custom message

**Returns:** User-friendly error message

**Example:**
```dart
final message = AppErrorHandler.handleApiError(404);
// Returns: "Không tìm thấy dữ liệu. Vui lòng thử lại."
```

---

### MemoryLeakPrevention
Utility for preventing memory leaks.

#### Methods

##### `disposeSubscription`
```dart
static void disposeSubscription(StreamSubscription? subscription)
```
Safely disposes stream subscription.

**Parameters:**
- `subscription`: Subscription to dispose

**Example:**
```dart
StreamSubscription? _subscription;

@override
void dispose() {
  MemoryLeakPrevention.disposeSubscription(_subscription);
  super.dispose();
}
```

##### `closeStreamController`
```dart
static void closeStreamController(StreamController? controller)
```
Safely closes stream controller.

**Parameters:**
- `controller`: Controller to close

**Example:**
```dart
final controller = StreamController<int>();

// Later...
MemoryLeakPrevention.closeStreamController(controller);
```

##### `debounce`
```dart
static void debounce({
  required Duration duration,
  required VoidCallback action,
})
```
Debounces function calls.

**Parameters:**
- `duration`: Debounce duration
- `action`: Function to debounce

**Example:**
```dart
MemoryLeakPrevention.debounce(
  duration: Duration(milliseconds: 500),
  action: () => search(query),
);
```

---

## State Management

### WallpaperBrowserNotifier
State notifier for browse feature.

#### Methods

##### `loadWallpapers`
```dart
Future<void> loadWallpapers()
```
Loads initial wallpapers.

**Example:**
```dart
ref.read(wallpaperBrowserNotifierProvider.notifier).loadWallpapers();
```

##### `loadMore`
```dart
Future<void> loadMore()
```
Loads more wallpapers (pagination).

**Example:**
```dart
ref.read(wallpaperBrowserNotifierProvider.notifier).loadMore();
```

##### `refresh`
```dart
Future<void> refresh()
```
Refreshes wallpaper list.

**Example:**
```dart
ref.read(wallpaperBrowserNotifierProvider.notifier).refresh();
```

##### `filterByCategory`
```dart
Future<void> filterByCategory(String? categoryId)
```
Filters wallpapers by category.

**Parameters:**
- `categoryId`: Category ID to filter by, `null` for all

**Example:**
```dart
ref.read(wallpaperBrowserNotifierProvider.notifier)
  .filterByCategory('nature');
```

---

### SearchNotifier
State notifier for search feature.

#### Methods

##### `searchWallpapers`
```dart
Future<void> searchWallpapers(String query)
```
Searches wallpapers with debouncing.

**Parameters:**
- `query`: Search query

**Example:**
```dart
ref.read(searchNotifierProvider.notifier)
  .searchWallpapers('mountains');
```

##### `clearSearch`
```dart
void clearSearch()
```
Clears search results.

**Example:**
```dart
ref.read(searchNotifierProvider.notifier).clearSearch();
```

---

### DownloadNotifier
State notifier for download feature.

#### Methods

##### `downloadWallpaper`
```dart
Future<void> downloadWallpaper(Wallpaper wallpaper)
```
Downloads wallpaper with progress tracking.

**Parameters:**
- `wallpaper`: Wallpaper to download

**Example:**
```dart
ref.read(downloadNotifierProvider.notifier)
  .downloadWallpaper(wallpaper);
```

##### `retryDownload`
```dart
Future<void> retryDownload(Wallpaper wallpaper)
```
Retries failed download.

**Parameters:**
- `wallpaper`: Wallpaper to retry

**Example:**
```dart
ref.read(downloadNotifierProvider.notifier)
  .retryDownload(wallpaper);
```

---

## Data Layer

### WallpaperRepository
Repository for wallpaper data.

#### Methods

##### `getWallpapers`
```dart
Future<List<Wallpaper>> getWallpapers({
  int page = 1,
  int perPage = 20,
  String? category,
})
```
Fetches wallpapers with pagination.

**Parameters:**
- `page`: Page number (default: 1)
- `perPage`: Items per page (default: 20)
- `category`: Optional category filter

**Returns:** List of wallpapers

**Example:**
```dart
final wallpapers = await repository.getWallpapers(
  page: 1,
  perPage: 20,
  category: 'nature',
);
```

##### `getWallpaperById`
```dart
Future<Wallpaper> getWallpaperById(String id)
```
Fetches single wallpaper by ID.

**Parameters:**
- `id`: Wallpaper ID

**Returns:** Wallpaper object

**Throws:** Exception if not found

**Example:**
```dart
final wallpaper = await repository.getWallpaperById('123');
```

---

### FavoriteRepository
Repository for favorites management.

#### Methods

##### `addFavorite`
```dart
Future<void> addFavorite(Wallpaper wallpaper)
```
Adds wallpaper to favorites.

**Parameters:**
- `wallpaper`: Wallpaper to add

**Example:**
```dart
await repository.addFavorite(wallpaper);
```

##### `removeFavorite`
```dart
Future<void> removeFavorite(String wallpaperId)
```
Removes wallpaper from favorites.

**Parameters:**
- `wallpaperId`: Wallpaper ID to remove

**Example:**
```dart
await repository.removeFavorite('123');
```

##### `isFavorite`
```dart
Future<bool> isFavorite(String wallpaperId)
```
Checks if wallpaper is favorited.

**Parameters:**
- `wallpaperId`: Wallpaper ID to check

**Returns:** `true` if favorited

**Example:**
```dart
final isFav = await repository.isFavorite('123');
```

##### `watchFavorites`
```dart
Stream<List<Wallpaper>> watchFavorites()
```
Watches favorites for changes.

**Returns:** Stream of favorite wallpapers

**Example:**
```dart
repository.watchFavorites().listen((favorites) {
  print('Favorites updated: ${favorites.length}');
});
```

---

## Domain Layer

### Entities

#### Wallpaper
```dart
class Wallpaper {
  final String id;
  final String title;
  final String? description;
  final String thumbnailUrl;
  final String fullResolutionUrl;
  final WallpaperResolution resolution;
  final List<String> categories;
  final String? author;
  final DateTime createdAt;
}
```

#### WallpaperResolution
```dart
class WallpaperResolution {
  final int width;
  final int height;
  
  double get aspectRatio => width / height;
}
```

#### Category
```dart
class Category {
  final String id;
  final String name;
  final String? iconUrl;
  final int wallpaperCount;
}
```

#### Collection
```dart
class Collection {
  final String id;
  final String name;
  final String description;
  final List<String> wallpaperIds;
  final String? coverImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  int get wallpaperCount => wallpaperIds.length;
}
```

---

## Error Handling

### Custom Exceptions

#### NetworkException
```dart
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  
  NetworkException(this.message, {this.statusCode});
}
```

#### DownloadException
```dart
class DownloadException implements Exception {
  final String message;
  final String? wallpaperId;
  
  DownloadException(this.message, {this.wallpaperId});
}
```

#### CacheException
```dart
class CacheException implements Exception {
  final String message;
  
  CacheException(this.message);
}
```

---

## Best Practices

### State Management
```dart
// ✅ Good: Use ref.read for one-time reads
void onButtonPressed() {
  ref.read(notifierProvider.notifier).doSomething();
}

// ✅ Good: Use ref.watch for reactive updates
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(stateProvider);
  return Text(state.value);
}

// ❌ Bad: Don't use ref.watch in callbacks
void onButtonPressed() {
  final state = ref.watch(stateProvider); // Wrong!
}
```

### Error Handling
```dart
// ✅ Good: Use AppErrorHandler
try {
  await operation();
} catch (e, stackTrace) {
  final message = AppErrorHandler.handleError(e, stackTrace: stackTrace);
  showError(message);
}

// ❌ Bad: Show raw error
try {
  await operation();
} catch (e) {
  showError(e.toString()); // Not user-friendly
}
```

### Memory Management
```dart
// ✅ Good: Dispose subscriptions
@override
void dispose() {
  MemoryLeakPrevention.disposeSubscription(_subscription);
  super.dispose();
}

// ❌ Bad: Forget to dispose
@override
void dispose() {
  super.dispose(); // Memory leak!
}
```

---

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev/)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Last Updated:** April 26, 2026
**Version:** 1.0.5
