import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/wallpaper_target.dart';
import '../../domain/providers/wallpaper_setter_domain_providers.dart';

/// Button widget for setting wallpaper
/// Requirements: 5.1, 5.2, 5.4, 5.5
class SetWallpaperButton extends ConsumerStatefulWidget {
  final File imageFile;
  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  const SetWallpaperButton({
    super.key,
    required this.imageFile,
    this.onSuccess,
    this.onError,
  });

  @override
  ConsumerState<SetWallpaperButton> createState() => _SetWallpaperButtonState();
}

class _SetWallpaperButtonState extends ConsumerState<SetWallpaperButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final useCase = ref.watch(setWallpaperUseCaseProvider);
    final isSupported = useCase.isSupported();

    if (!isSupported) {
      return _buildUnsupportedButton(context);
    }

    return ElevatedButton.icon(
      onPressed: _isLoading
          ? null
          : () => _showTargetSelection(context, useCase),
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.wallpaper),
      label: Text(_isLoading ? 'Đang đặt...' : 'Đặt làm hình nền'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  Widget _buildUnsupportedButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showUnsupportedDialog(context),
      icon: const Icon(Icons.info_outline),
      label: const Text('Hướng dẫn đặt hình nền'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  void _showTargetSelection(BuildContext context, dynamic useCase) {
    final supportedTargets =
        useCase.getSupportedTargets() as List<WallpaperTarget>;

    if (supportedTargets.length == 1) {
      // Only one option, set directly
      _setWallpaper(supportedTargets.first);
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Chọn vị trí đặt hình nền',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...supportedTargets.map(
              (target) => ListTile(
                leading: Icon(_getTargetIcon(target)),
                title: Text(target.displayName),
                onTap: () {
                  Navigator.pop(context);
                  _setWallpaper(target);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  IconData _getTargetIcon(WallpaperTarget target) {
    switch (target) {
      case WallpaperTarget.homeScreen:
        return Icons.home;
      case WallpaperTarget.lockScreen:
        return Icons.lock;
      case WallpaperTarget.both:
        return Icons.wallpaper;
    }
  }

  Future<void> _setWallpaper(WallpaperTarget target) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final useCase = ref.read(setWallpaperUseCaseProvider);
      final success = await useCase.execute(widget.imageFile, target);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã đặt hình nền cho ${target.displayName}'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSuccess?.call();
      } else {
        _showErrorDialog(context);
        widget.onError?.call();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showErrorDialog(context, error: e.toString());
      widget.onError?.call();
    }
  }

  void _showUnsupportedDialog(BuildContext context) {
    String instructions = '';
    String title = 'Hướng dẫn đặt hình nền';

    if (kIsWeb) {
      instructions = '''
Trình duyệt web không hỗ trợ đặt hình nền tự động.

Hướng dẫn:
1. Tải hình nền về máy (nút Download)
2. Mở Settings trên thiết bị
3. Chọn Wallpaper/Background
4. Chọn hình ảnh đã tải
''';
    } else if (Platform.isIOS) {
      title = 'Hình nền đã được lưu';
      instructions = '''
Hình nền đã được lưu vào thư viện ảnh.

Để đặt làm hình nền:
1. Mở Settings > Wallpaper
2. Chọn "Choose a New Wallpaper"
3. Chọn hình ảnh vừa lưu từ Photos
4. Chọn "Set" và chọn vị trí (Lock Screen, Home Screen, hoặc Both)
''';
    } else {
      instructions = 'Nền tảng này chưa được hỗ trợ.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(instructions),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, {String? error}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(error ?? 'Không thể đặt hình nền. Vui lòng thử lại sau.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
