import 'dart:async';

/// Utility class for debouncing search queries
/// Requirements: 2.4, 2.5
class SearchQueryDebouncer {
  final Duration delay;
  Timer? _timer;

  SearchQueryDebouncer({this.delay = const Duration(milliseconds: 500)});

  /// Debounce a function call
  ///
  /// [callback] - Function to execute after delay
  void debounce(void Function() callback) {
    // Cancel any existing timer
    _timer?.cancel();

    // Create a new timer
    _timer = Timer(delay, callback);
  }

  /// Cancel any pending debounced calls
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Dispose of the debouncer
  void dispose() {
    cancel();
  }
}
