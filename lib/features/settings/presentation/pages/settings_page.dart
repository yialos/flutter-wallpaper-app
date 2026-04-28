import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../notifiers/cache_manager_notifier.dart';
import '../providers/settings_providers.dart';

/// Settings page with cache management
/// Requirements: 7.5
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Load cache size on page initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cacheManagerNotifierProvider.notifier).loadCacheSize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cacheState = ref.watch(cacheManagerNotifierProvider);
    final themeMode = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: [
          _buildAppearanceSection(context, themeMode),
          const Divider(),
          _buildCacheSection(context, cacheState),
          const Divider(),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, ThemeMode themeMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Giao diện',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: Icon(
            themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
          ),
          title: const Text('Chế độ tối'),
          subtitle: Text(_getThemeModeText(themeMode)),
          trailing: Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              ref
                  .read(themeNotifierProvider.notifier)
                  .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCacheSection(
    BuildContext context,
    CacheManagerState cacheState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Bộ nhớ đệm',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: const Text('Kích thước bộ nhớ đệm'),
          subtitle: Text(_formatCacheSize(cacheState.cacheSize)),
          trailing: cacheState.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Xóa bộ nhớ đệm'),
          subtitle: const Text('Giải phóng dung lượng lưu trữ'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showClearCacheConfirmation(context),
        ),
        if (cacheState.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              cacheState.error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Về ứng dụng',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Phiên bản'),
          subtitle: const Text('1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('Giới thiệu'),
          subtitle: const Text('Ứng dụng hình nền đa nền tảng'),
        ),
      ],
    );
  }

  String _formatCacheSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Chế độ sáng';
      case ThemeMode.dark:
        return 'Chế độ tối';
      case ThemeMode.system:
        return 'Theo hệ thống';
    }
  }

  void _showClearCacheConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa bộ nhớ đệm?'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa tất cả bộ nhớ đệm? Hành động này sẽ giải phóng dung lượng lưu trữ nhưng hình nền sẽ cần tải lại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              await ref
                  .read(cacheManagerNotifierProvider.notifier)
                  .clearCache();
              if (mounted) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Đã xóa bộ nhớ đệm')),
                );
              }
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
