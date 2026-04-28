import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/core/config/app_config.dart';
import 'dio_network_client.dart';
import 'network_client.dart';

/// Provider for AppConfig singleton
/// Requirements: 10.1, 10.2, 10.3, 10.4, 10.5
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.current();
});

/// Provider for NetworkClient singleton
/// Requirements: 8.3, 8.5
final networkClientProvider = Provider<NetworkClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return DioNetworkClient(config: config);
});
