import 'package:flutter/material.dart';

/// Accessible color palette that meets WCAG AA standards
/// Requirements: 10.5, Task 28.1
class AccessibleColors {
  AccessibleColors._();

  // Light theme colors with WCAG AA compliance
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightPrimary = Color(0xFF1976D2); // Blue 700
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightSecondary = Color(0xFF388E3C); // Green 700
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFD32F2F); // Red 700
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF212121); // Grey 900
  static const Color lightTextSecondary = Color(0xFF757575); // Grey 600

  // Dark theme colors with WCAG AA compliance
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkPrimary = Color(0xFF90CAF9); // Blue 200
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkSecondary = Color(0xFF81C784); // Green 300
  static const Color darkOnSecondary = Color(0xFF000000);
  static const Color darkError = Color(0xFFEF5350); // Red 400
  static const Color darkOnError = Color(0xFF000000);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  /// Validates if a color combination meets WCAG AA standards
  static bool isAccessible(Color foreground, Color background) {
    final contrastRatio = getContrastRatio(foreground, background);
    return contrastRatio >= 4.5; // WCAG AA for normal text
  }

  /// Calculates contrast ratio between two colors
  static double getContrastRatio(Color foreground, Color background) {
    final luminance1 = foreground.computeLuminance();
    final luminance2 = background.computeLuminance();

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Gets an accessible text color for the given background
  static Color getAccessibleTextColor(Color background) {
    final luminance = background.computeLuminance();
    // If background is dark, use light text; if light, use dark text
    return luminance > 0.5 ? lightText : darkText;
  }

  /// Creates an accessible color scheme for light theme
  static ColorScheme createLightColorScheme() {
    return const ColorScheme.light(
      primary: lightPrimary,
      onPrimary: lightOnPrimary,
      secondary: lightSecondary,
      onSecondary: lightOnSecondary,
      error: lightError,
      onError: lightOnError,
      surface: lightSurface,
      onSurface: lightText,
    );
  }

  /// Creates an accessible color scheme for dark theme
  static ColorScheme createDarkColorScheme() {
    return const ColorScheme.dark(
      primary: darkPrimary,
      onPrimary: darkOnPrimary,
      secondary: darkSecondary,
      onSecondary: darkOnSecondary,
      error: darkError,
      onError: darkOnError,
      surface: darkSurface,
      onSurface: darkText,
    );
  }

  /// Validates all color combinations in a theme
  static Map<String, bool> validateTheme(ColorScheme scheme) {
    return {
      'primary-onPrimary': isAccessible(scheme.onPrimary, scheme.primary),
      'secondary-onSecondary': isAccessible(
        scheme.onSecondary,
        scheme.secondary,
      ),
      'error-onError': isAccessible(scheme.onError, scheme.error),
      'surface-onSurface': isAccessible(scheme.onSurface, scheme.surface),
    };
  }

  /// Gets contrast ratio report for a theme
  static Map<String, double> getThemeContrastReport(ColorScheme scheme) {
    return {
      'primary-onPrimary': getContrastRatio(scheme.onPrimary, scheme.primary),
      'secondary-onSecondary': getContrastRatio(
        scheme.onSecondary,
        scheme.secondary,
      ),
      'error-onError': getContrastRatio(scheme.onError, scheme.error),
      'surface-onSurface': getContrastRatio(scheme.onSurface, scheme.surface),
    };
  }
}

/// Extension on ColorScheme for accessibility checks
extension AccessibleColorSchemeExtension on ColorScheme {
  /// Checks if this color scheme meets WCAG AA standards
  bool get isAccessible {
    final validations = AccessibleColors.validateTheme(this);
    return validations.values.every((isValid) => isValid);
  }

  /// Gets contrast ratio report for this color scheme
  Map<String, double> get contrastReport {
    return AccessibleColors.getThemeContrastReport(this);
  }
}
