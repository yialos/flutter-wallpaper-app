import 'package:flutter/material.dart';
import 'accessible_colors.dart';

/// Application theme configuration with accessibility support
/// Requirements: 10.5, Task 28.1
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Minimum touch target size (WCAG guideline)
  static const double minTouchTargetSize = 48.0;

  /// Light theme with WCAG AA compliant colors
  static ThemeData get lightTheme {
    final colorScheme = AccessibleColors.createLightColorScheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      // Ensure minimum touch target sizes
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      // AppBar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: colorScheme.surface,
      ),
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      // Text theme with accessible sizes
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: colorScheme.onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: colorScheme.onSurface),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AccessibleColors.lightTextSecondary,
        ),
      ),
      // Icon theme
      iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
      // Button themes with minimum sizes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(minTouchTargetSize, minTouchTargetSize),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(minTouchTargetSize, minTouchTargetSize),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(minTouchTargetSize, minTouchTargetSize),
        ),
      ),
    );
  }

  /// Dark theme with WCAG AA compliant colors
  static ThemeData get darkTheme {
    final colorScheme = AccessibleColors.createDarkColorScheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      // Ensure minimum touch target sizes
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      // AppBar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: colorScheme.surface,
      ),
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: colorScheme.surface,
      ),
      // Text theme with accessible sizes
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: colorScheme.onSurface),
        bodyMedium: TextStyle(fontSize: 14, color: colorScheme.onSurface),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AccessibleColors.darkTextSecondary,
        ),
      ),
      // Icon theme
      iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
      // Button themes with minimum sizes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(minTouchTargetSize, minTouchTargetSize),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(minTouchTargetSize, minTouchTargetSize),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(minTouchTargetSize, minTouchTargetSize),
        ),
      ),
    );
  }

  /// Validates if current theme meets accessibility standards
  static bool validateTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return colorScheme.isAccessible;
  }

  /// Gets accessibility report for current theme
  static Map<String, double> getAccessibilityReport(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return colorScheme.contrastReport;
  }
}
