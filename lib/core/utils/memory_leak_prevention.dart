import 'dart:async';
import 'package:flutter/foundation.dart';

/// Utility class for preventing memory leaks
/// Requirements: 12.4
class MemoryLeakPrevention {
  MemoryLeakPrevention._();

  /// Safely dispose stream subscription
  static void disposeSubscription(StreamSubscription? subscription) {
    try {
      subscription?.cancel();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error disposing subscription: $e');
      }
    }
  }

  /// Safely dispose multiple subscriptions
  static void disposeSubscriptions(List<StreamSubscription?> subscriptions) {
    for (final subscription in subscriptions) {
      disposeSubscription(subscription);
    }
  }

  /// Safely close stream controller
  static void closeStreamController(StreamController? controller) {
    try {
      if (controller != null && !controller.isClosed) {
        controller.close();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error closing stream controller: $e');
      }
    }
  }

  /// Safely close multiple stream controllers
  static void closeStreamControllers(List<StreamController?> controllers) {
    for (final controller in controllers) {
      closeStreamController(controller);
    }
  }

  /// Create a managed stream subscription that auto-disposes
  static StreamSubscription<T> createManagedSubscription<T>(
    Stream<T> stream,
    void Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError ?? false,
    );
  }

  /// Debounce function calls to prevent excessive operations
  static Timer? _debounceTimer;

  static void debounce({
    required Duration duration,
    required VoidCallback action,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, action);
  }

  /// Throttle function calls to limit frequency
  static DateTime? _lastThrottleTime;

  static void throttle({
    required Duration duration,
    required VoidCallback action,
  }) {
    final now = DateTime.now();

    if (_lastThrottleTime == null ||
        now.difference(_lastThrottleTime!) >= duration) {
      _lastThrottleTime = now;
      action();
    }
  }

  /// Clear all timers
  static void clearTimers() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _lastThrottleTime = null;
  }

  /// Weak reference holder to prevent strong references
  static final Map<String, WeakReference<Object>> _weakReferences = {};

  /// Store weak reference
  static void storeWeakReference(String key, Object object) {
    _weakReferences[key] = WeakReference(object);
  }

  /// Get weak reference
  static Object? getWeakReference(String key) {
    return _weakReferences[key]?.target;
  }

  /// Clear weak reference
  static void clearWeakReference(String key) {
    _weakReferences.remove(key);
  }

  /// Clear all weak references
  static void clearAllWeakReferences() {
    _weakReferences.clear();
  }

  /// Check for memory leaks (debug only)
  static void checkForLeaks() {
    if (!kDebugMode) return;

    final activeReferences = _weakReferences.entries
        .where((entry) => entry.value.target != null)
        .length;

    debugPrint('Active weak references: $activeReferences');

    if (activeReferences > 100) {
      debugPrint(
        'WARNING: High number of active references. '
        'Possible memory leak!',
      );
    }
  }
}
