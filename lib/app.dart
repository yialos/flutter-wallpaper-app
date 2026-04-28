import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/core/theme/app_theme.dart';
import 'package:wallpaper_app/core/theme/theme_notifier.dart';
import 'package:wallpaper_app/core/utils/memory_utils.dart';
import 'package:wallpaper_app/features/main/presentation/pages/main_navigation_page.dart';

/// Main application widget
class WallpaperApp extends ConsumerStatefulWidget {
  const WallpaperApp({super.key});

  @override
  ConsumerState<WallpaperApp> createState() => _WallpaperAppState();
}

class _WallpaperAppState extends ConsumerState<WallpaperApp> {
  @override
  void initState() {
    super.initState();
    // Optimize memory on app start
    MemoryUtils().optimizeImageCache();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Wallpaper App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const MainNavigationPage().withMemoryOptimization(),
    );
  }
}
