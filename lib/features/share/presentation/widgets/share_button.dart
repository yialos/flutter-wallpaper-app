import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallpaper_app/core/utils/accessibility_utils.dart';
import 'package:wallpaper_app/features/browse/domain/entities/wallpaper.dart';
import '../providers/share_providers.dart';

/// Share button widget for wallpapers
class ShareButton extends ConsumerStatefulWidget {
  final Wallpaper wallpaper;
  final String? downloadedImagePath;
  final bool showLabel;
  final Color? iconColor;
  final double? iconSize;

  const ShareButton({
    super.key,
    required this.wallpaper,
    this.downloadedImagePath,
    this.showLabel = false,
    this.iconColor,
    this.iconSize,
  });

  @override
  ConsumerState<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends ConsumerState<ShareButton> {
  bool _isSharing = false;

  Future<void> _handleShare() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final shareUseCase = ref.read(shareWallpaperUseCaseProvider);

      final result = await shareUseCase.execute(
        wallpaper: widget.wallpaper,
        imagePath: widget.downloadedImagePath,
        shareImageIfAvailable: true,
      );

      if (mounted) {
        // Show success message based on result
        if (result.status == ShareResultStatus.success) {
          _showSnackBar('Đã chia sẻ thành công!', isError: false);
        } else if (result.status == ShareResultStatus.dismissed) {
          // User dismissed share sheet - no message needed
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Không thể chia sẻ: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showLabel) {
      return Semantics(
        label: 'Chia sẻ hình nền',
        hint: 'Nhấn để chia sẻ hình nền này',
        button: true,
        enabled: !_isSharing,
        child: ElevatedButton.icon(
          onPressed: _isSharing ? null : _handleShare,
          icon: _isSharing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  Icons.share,
                  size: widget.iconSize ?? 20,
                  color: widget.iconColor,
                ),
          label: Text(_isSharing ? 'Đang chia sẻ...' : 'Chia sẻ'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      );
    }

    return Semantics(
      label: 'Chia sẻ hình nền',
      hint: 'Nhấn để chia sẻ hình nền này',
      button: true,
      enabled: !_isSharing,
      child: IconButton(
        onPressed: _isSharing ? null : _handleShare,
        icon: _isSharing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.share,
                size: widget.iconSize ?? 24,
                color: widget.iconColor ?? Theme.of(context).iconTheme.color,
              ),
        tooltip: 'Chia sẻ',
      ),
    ).withTouchTarget();
  }
}
