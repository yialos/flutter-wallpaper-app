import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallpaper_app/app.dart';
import 'package:wallpaper_app/core/constants/app_constants.dart';
import 'package:wallpaper_app/features/collections/data/models/collection_entity.dart';
import 'package:wallpaper_app/features/favorites/data/models/favorite_wallpaper_entity.dart';
import 'package:wallpaper_app/features/settings/data/models/cached_wallpaper_metadata.dart';
import 'package:wallpaper_app/features/settings/data/datasources/cache_metadata_local_datasource.dart';
import 'package:wallpaper_app/features/settings/data/providers/cache_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(FavoriteWallpaperEntityAdapter());
  Hive.registerAdapter(CachedWallpaperMetadataAdapter());
  Hive.registerAdapter(CollectionEntityAdapter());

  // Open Hive boxes
  await Hive.openBox<FavoriteWallpaperEntity>(AppConstants.favoritesBoxName);
  final cacheMetadataBox = await Hive.openBox<CachedWallpaperMetadata>(
    AppConstants.cacheMetadataBoxName,
  );
  await Hive.openBox(AppConstants.settingsBoxName);

  // Initialize cache metadata data source
  final cacheMetadataDataSource = CacheMetadataLocalDataSourceImpl(
    cacheMetadataBox,
  );

  runApp(
    ProviderScope(
      overrides: [
        cacheMetadataLocalDataSourceProvider.overrideWithValue(
          cacheMetadataDataSource,
        ),
      ],
      child: const WallpaperApp(),
    ),
  );
}
