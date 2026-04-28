import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/memory_leak_prevention.dart';

/// Monitor for network connectivity status
/// Requirements: 8.1, 8.4
class ConnectivityMonitor {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  /// Stream of connectivity status (true = online, false = offline)
  Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Current connectivity status
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(result);

    // Listen for connectivity changes with memory leak prevention
    _subscription = MemoryLeakPrevention.createManagedSubscription(
      _connectivity.onConnectivityChanged,
      _updateConnectivityStatus,
      onError: (error) {
        // On error, assume offline
        _isOnline = false;
        _connectivityController.add(false);
      },
    );
  }

  /// Update connectivity status based on result
  void _updateConnectivityStatus(ConnectivityResult result) {
    // Check if connection is available
    final hasConnection = result != ConnectivityResult.none;

    if (_isOnline != hasConnection) {
      _isOnline = hasConnection;
      _connectivityController.add(hasConnection);
    }
  }

  /// Dispose resources
  void dispose() {
    MemoryLeakPrevention.disposeSubscription(_subscription);
    MemoryLeakPrevention.closeStreamController(_connectivityController);
  }
}
