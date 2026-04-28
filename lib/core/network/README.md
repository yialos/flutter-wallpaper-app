# Network Layer

This directory contains the network layer implementation for the Wallpaper App.

## Components

### NetworkClient
Abstract interface for network operations. Implemented by `DioNetworkClient`.

**Features:**
- GET and POST requests
- File downloads with progress tracking
- Automatic error handling

### DioNetworkClient
Dio-based implementation of `NetworkClient`.

**Features:**
- Configured with base URL, timeouts, and headers
- Automatic retry logic via `RetryInterceptor`
- Converts Dio errors to app-specific exceptions
- Optional logging in debug mode

### RetryInterceptor
Dio interceptor that automatically retries failed requests.

**Features:**
- Exponential backoff (500ms, 1s, 2s)
- Maximum 3 retries
- Retries on: timeouts, connection errors, 5xx errors, 429 (rate limiting)
- Does not retry: 4xx errors (except 429), cancelled requests

### ConnectivityMonitor
Monitors network connectivity status.

**Features:**
- Real-time connectivity status stream
- Check current connectivity status
- Supports: WiFi, Mobile, Ethernet, VPN
- Automatic cleanup on dispose

## Usage

### Basic GET Request

```dart
final networkClient = ref.read(networkClientProvider);

try {
  final response = await networkClient.get('/wallpapers', 
    queryParameters: {'page': 1, 'pageSize': 20},
  );
  // Handle response
} on NetworkException catch (e) {
  // Handle error
  final message = ErrorHandler.getUserMessage(e);
}
```

### Download with Progress

```dart
final networkClient = ref.read(networkClientProvider);

await networkClient.download(
  'https://example.com/wallpaper.jpg',
  '/path/to/save/wallpaper.jpg',
  onReceiveProgress: (received, total) {
    final progress = received / total;
    print('Download progress: ${(progress * 100).toStringAsFixed(0)}%');
  },
);
```

### Monitor Connectivity

```dart
// Watch connectivity stream
ref.listen(connectivityStreamProvider, (previous, next) {
  next.when(
    data: (status) {
      if (status == ConnectivityStatus.offline) {
        // Show offline indicator
      } else {
        // Hide offline indicator
      }
    },
    loading: () {},
    error: (_, __) {},
  );
});

// Check current status
final status = await ref.read(connectivityStatusProvider.future);
```

## Error Handling

All network errors are converted to `NetworkException` with appropriate error types:

- `NetworkErrorType.noConnection` - No internet connection
- `NetworkErrorType.timeout` - Request timeout
- `NetworkErrorType.serverError` - 5xx server errors
- `NetworkErrorType.unauthorized` - 401 unauthorized
- `NetworkErrorType.notFound` - 404 not found
- `NetworkErrorType.badRequest` - 4xx client errors
- `NetworkErrorType.unknown` - Other errors

Use `ErrorHandler.getUserMessage()` to get user-friendly Vietnamese error messages.

## Testing

Mock the `NetworkClient` interface for testing:

```dart
class MockNetworkClient extends Mock implements NetworkClient {}

test('should fetch wallpapers', () async {
  final mockClient = MockNetworkClient();
  when(() => mockClient.get('/wallpapers'))
    .thenAnswer((_) async => Response(data: {...}));
  
  // Test your code
});
```
