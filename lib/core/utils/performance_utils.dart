import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Utility class for performance monitoring
/// Requirements: 12.1, 12.2
class PerformanceUtils {
  static final PerformanceUtils _instance = PerformanceUtils._internal();
  factory PerformanceUtils() => _instance;
  PerformanceUtils._internal();

  int _frameCount = 0;
  Duration _totalFrameTime = Duration.zero;
  DateTime? _lastResetTime;

  /// Start monitoring frame performance
  void startMonitoring() {
    _lastResetTime = DateTime.now();
    SchedulerBinding.instance.addTimingsCallback(_onFrameTiming);
  }

  /// Stop monitoring frame performance
  void stopMonitoring() {
    SchedulerBinding.instance.removeTimingsCallback(_onFrameTiming);
  }

  /// Callback for frame timing
  void _onFrameTiming(List<FrameTiming> timings) {
    for (final timing in timings) {
      _frameCount++;
      _totalFrameTime += timing.totalSpan;
    }
  }

  /// Get average FPS
  double getAverageFPS() {
    if (_frameCount == 0) return 0;

    final avgFrameTime = _totalFrameTime.inMicroseconds / _frameCount;
    final fps = 1000000 / avgFrameTime; // Convert to FPS

    return fps;
  }

  /// Reset statistics
  void reset() {
    _frameCount = 0;
    _totalFrameTime = Duration.zero;
    _lastResetTime = DateTime.now();
  }

  /// Get frame statistics
  Map<String, dynamic> getStatistics() {
    final now = DateTime.now();
    final elapsed = _lastResetTime != null
        ? now.difference(_lastResetTime!)
        : Duration.zero;

    return {
      'frameCount': _frameCount,
      'averageFPS': getAverageFPS(),
      'elapsedTime': elapsed.inSeconds,
      'averageFrameTime': _frameCount > 0
          ? (_totalFrameTime.inMilliseconds / _frameCount).toStringAsFixed(2)
          : '0',
    };
  }
}

/// Extension for easy performance monitoring
extension PerformanceMonitoring on Widget {
  /// Wrap widget with performance monitoring
  Widget withPerformanceMonitoring() {
    return PerformanceMonitorWidget(child: this);
  }
}

/// Widget that monitors performance of its child
class PerformanceMonitorWidget extends StatefulWidget {
  final Widget child;

  const PerformanceMonitorWidget({super.key, required this.child});

  @override
  State<PerformanceMonitorWidget> createState() =>
      _PerformanceMonitorWidgetState();
}

class _PerformanceMonitorWidgetState extends State<PerformanceMonitorWidget> {
  final _performanceUtils = PerformanceUtils();

  @override
  void initState() {
    super.initState();
    _performanceUtils.startMonitoring();
  }

  @override
  void dispose() {
    _performanceUtils.stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
