import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connectivity_monitor.dart';

/// Provider for ConnectivityMonitor singleton
/// Requirements: 8.1, 8.4
final connectivityMonitorProvider = Provider<ConnectivityMonitor>((ref) {
  final monitor = ConnectivityMonitor();
  monitor.initialize();

  // Dispose when provider is disposed
  ref.onDispose(() {
    monitor.dispose();
  });

  return monitor;
});

/// Provider for connectivity status stream
/// Requirements: 8.1, 8.4
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final monitor = ref.watch(connectivityMonitorProvider);
  return monitor.connectivityStream;
});

/// Provider for current connectivity status
/// Requirements: 8.1, 8.4
final isOnlineProvider = Provider<bool>((ref) {
  final connectivityAsync = ref.watch(connectivityStreamProvider);

  return connectivityAsync.when(
    data: (isOnline) => isOnline,
    loading: () => true, // Assume online while loading
    error: (_, _) => false, // Assume offline on error
  );
});
