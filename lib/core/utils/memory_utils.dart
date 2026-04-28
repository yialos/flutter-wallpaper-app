import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Utility class for memory management
/// Requirements: 7.3, 12.4
class MemoryUtils {
  static final MemoryUtils _instance = MemoryUtils._internal();
  factory MemoryUtils() => _instance;
  MemoryUtils._internal();

  /// Clear image cache to free memory
  Future<void> clearImageCache() async {
    try {
      // Clear Flutter's image cache
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      if (kDebugMode) {
        print('Image cache cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing image cache: $e');
      }
    }
  }

  /// Optimize image cache settings
  void optimizeImageCache() {
    // Set maximum cache size (100 images)
    PaintingBinding.instance.imageCache.maximumSize = 100;

    // Set maximum cache size in bytes (50 MB)
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;

    if (kDebugMode) {
      print('Image cache optimized: max 100 images, 50MB');
    }
  }

  /// Get current image cache statistics
  Map<String, dynamic> getImageCacheStats() {
    final cache = PaintingBinding.instance.imageCache;

    return {
      'currentSize': cache.currentSize,
      'maximumSize': cache.maximumSize,
      'currentSizeBytes': cache.currentSizeBytes,
      'maximumSizeBytes': cache.maximumSizeBytes,
      'liveImageCount': cache.liveImageCount,
      'pendingImageCount': cache.pendingImageCount,
    };
  }

  /// Clear cache manager cache
  Future<void> clearCacheManagerCache() async {
    try {
      await DefaultCacheManager().emptyCache();

      if (kDebugMode) {
        print('Cache manager cache cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing cache manager: $e');
      }
    }
  }

  /// Get cache manager statistics
  Future<Map<String, dynamic>> getCacheManagerStats() async {
    try {
      // Simple estimation - just return 0 for now
      // Full implementation would require accessing cache files directly
      return {
        'totalSize': 0,
        'fileCount': 0,
        'note': 'Cache stats not fully implemented',
      };
    } catch (e) {
      return {'totalSize': 0, 'fileCount': 0, 'error': e.toString()};
    }
  }

  /// Perform memory cleanup
  Future<void> performMemoryCleanup() async {
    await clearImageCache();

    // Force garbage collection (only in debug mode)
    if (kDebugMode) {
      print('Memory cleanup performed');
    }
  }

  /// Get memory usage estimate
  Map<String, dynamic> getMemoryUsageEstimate() {
    final imageCache = PaintingBinding.instance.imageCache;

    // Estimate memory usage
    final imageCacheBytes = imageCache.currentSizeBytes;
    final imageCacheMB = (imageCacheBytes / (1024 * 1024)).toStringAsFixed(2);

    return {
      'imageCacheMB': imageCacheMB,
      'imageCacheBytes': imageCacheBytes,
      'imageCount': imageCache.currentSize,
      'liveImages': imageCache.liveImageCount,
    };
  }
}

/// Extension for memory-efficient widgets
extension MemoryOptimization on Widget {
  /// Wrap widget with memory optimization
  Widget withMemoryOptimization() {
    return MemoryOptimizedWidget(child: this);
  }
}

/// Widget that optimizes memory usage
class MemoryOptimizedWidget extends StatefulWidget {
  final Widget child;

  const MemoryOptimizedWidget({super.key, required this.child});

  @override
  State<MemoryOptimizedWidget> createState() => _MemoryOptimizedWidgetState();
}

class _MemoryOptimizedWidgetState extends State<MemoryOptimizedWidget>
    with WidgetsBindingObserver {
  final _memoryUtils = MemoryUtils();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _memoryUtils.optimizeImageCache();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Clear cache when app goes to background
    if (state == AppLifecycleState.paused) {
      _memoryUtils.performMemoryCleanup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
