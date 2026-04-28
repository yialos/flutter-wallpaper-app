import 'package:flutter/material.dart';

/// Accessibility utilities for ensuring WCAG compliance
/// Requirements: 10.5, Task 28.1
class AccessibilityUtils {
  AccessibilityUtils._();

  /// Minimum touch target size as per WCAG guidelines (48x48 dp)
  static const double minTouchTargetSize = 48.0;

  /// Recommended touch target size for better UX (56x56 dp)
  static const double recommendedTouchTargetSize = 56.0;

  /// Minimum text size for readability
  static const double minTextSize = 12.0;

  /// Recommended text size for body text
  static const double bodyTextSize = 14.0;

  /// Recommended text size for titles
  static const double titleTextSize = 16.0;

  /// Ensures a widget meets minimum touch target size
  /// Wraps the child in a Container with minimum constraints
  static Widget ensureTouchTarget({
    required Widget child,
    double minSize = minTouchTargetSize,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
      child: child,
    );
  }

  /// Creates a semantically labeled button
  static Widget semanticButton({
    required String label,
    required VoidCallback onPressed,
    required Widget child,
    String? hint,
    bool enabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: enabled,
      child: child,
    );
  }

  /// Creates a semantically labeled image
  static Widget semanticImage({
    required String label,
    required Widget child,
    String? hint,
  }) {
    return Semantics(label: label, hint: hint, image: true, child: child);
  }

  /// Checks if color contrast meets WCAG AA standards (4.5:1 for normal text)
  static bool meetsContrastRatio(Color foreground, Color background) {
    final luminance1 = foreground.computeLuminance();
    final luminance2 = background.computeLuminance();

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    final contrastRatio = (lighter + 0.05) / (darker + 0.05);

    // WCAG AA requires 4.5:1 for normal text, 3:1 for large text
    return contrastRatio >= 4.5;
  }

  /// Gets contrast ratio between two colors
  static double getContrastRatio(Color foreground, Color background) {
    final luminance1 = foreground.computeLuminance();
    final luminance2 = background.computeLuminance();

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Creates an accessible text widget with proper sizing
  static Widget accessibleText(
    String text, {
    TextStyle? style,
    double minSize = minTextSize,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    final effectiveStyle = style ?? const TextStyle();
    final fontSize = effectiveStyle.fontSize ?? bodyTextSize;

    return Text(
      text,
      style: effectiveStyle.copyWith(
        fontSize: fontSize < minSize ? minSize : fontSize,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Announces a message to screen readers
  static void announce(BuildContext context, String message) {
    // Announce to screen readers using ScaffoldMessenger
    // This is a workaround since SemanticsService.announce is not available
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Creates a focus node with proper semantics
  static FocusNode createAccessibleFocusNode({
    String? debugLabel,
    bool skipTraversal = false,
  }) {
    return FocusNode(debugLabel: debugLabel, skipTraversal: skipTraversal);
  }
}

/// Extension on Widget for easy accessibility wrapping
extension AccessibilityWidgetExtension on Widget {
  /// Wraps widget with minimum touch target size
  Widget withTouchTarget({
    double minSize = AccessibilityUtils.minTouchTargetSize,
  }) {
    return AccessibilityUtils.ensureTouchTarget(child: this, minSize: minSize);
  }

  /// Wraps widget with semantic label
  Widget withSemantics({
    required String label,
    String? hint,
    bool button = false,
    bool image = false,
    bool enabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: button,
      image: image,
      enabled: enabled,
      child: this,
    );
  }
}
