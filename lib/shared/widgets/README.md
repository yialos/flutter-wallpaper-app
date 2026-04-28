# Shared Widgets

This directory contains reusable UI components used across the Wallpaper App.

## Error Widgets (Task 2)

### ErrorMessageWidget
Generic error message display with optional retry button.

**Usage:**
```dart
ErrorMessageWidget(
  message: 'Đã xảy ra lỗi',
  onRetry: () => _loadData(),
)
```

### ImageLoadingErrorWidget
Specialized error widget for image loading failures with placeholder.

**Usage:**
```dart
ImageLoadingErrorWidget(
  onRetry: () => _reloadImage(),
  width: 200,
  height: 300,
)
```

### OfflineIndicator
Banner widget to indicate offline status.

**Usage:**
```dart
if (isOffline) OfflineIndicator()
```

## Loading Widgets (Task 11.1)

### LoadingIndicator
Generic loading spinner with optional message.

**Usage:**
```dart
LoadingIndicator(
  message: 'Đang tải hình nền...',
  size: 40.0,
)
```

### ShimmerPlaceholder
Shimmer effect placeholder for loading states.

**Usage:**
```dart
ShimmerPlaceholder(
  width: 200,
  height: 300,
  borderRadius: BorderRadius.circular(8),
)
```

### WallpaperThumbnailShimmer
Specialized shimmer placeholder for wallpaper thumbnails in grid.

**Usage:**
```dart
WallpaperThumbnailShimmer(
  aspectRatio: 9 / 16,
)
```

## Common UI Components (Task 11.3)

### WallpaperThumbnailWidget
Displays wallpaper thumbnail with caching, loading, and error states.

**Features:**
- Automatic image caching with `cached_network_image`
- Shimmer loading placeholder
- Error handling with retry
- Tap gesture support

**Usage:**
```dart
WallpaperThumbnailWidget(
  wallpaper: wallpaper,
  onTap: () => _navigateToDetail(wallpaper),
  aspectRatio: 9 / 16,
)
```

### DownloadProgressWidget
Displays download progress with percentage and optional cancel button.

**Variants:**
- `DownloadProgressWidget`: Full card with progress bar
- `CompactDownloadProgressWidget`: Compact circular progress

**Usage:**
```dart
DownloadProgressWidget(
  progress: 0.65,
  message: 'Đang tải xuống...',
  onCancel: () => _cancelDownload(),
)

// Compact version
CompactDownloadProgressWidget(
  progress: 0.65,
  size: 24.0,
)
```

### FavoriteButton
Animated button for toggling favorite status.

**Features:**
- Scale animation on tap
- Filled/outlined heart icon
- Customizable colors

**Variants:**
- `FavoriteButton`: Full button with padding
- `CompactFavoriteIcon`: Icon only without button

**Usage:**
```dart
FavoriteButton(
  isFavorite: isFavorite,
  onToggle: () => _toggleFavorite(),
  size: 24.0,
  activeColor: Colors.red,
)

// Compact version
CompactFavoriteIcon(
  isFavorite: isFavorite,
  size: 20.0,
)
```

### CategoryChip
Chip widget for displaying and selecting categories.

**Features:**
- Selected/unselected states with animation
- Category icon support (placeholder for now)
- Wallpaper count badge

**Variants:**
- `CategoryChip`: Full chip with icon and count
- `SimpleCategoryChip`: Text-only chip

**Usage:**
```dart
CategoryChip(
  category: category,
  isSelected: selectedCategoryId == category.id,
  onTap: () => _selectCategory(category),
)

// Simple version
SimpleCategoryChip(
  categoryName: 'Nature',
  isSelected: isSelected,
  onTap: () => _selectCategory(),
)
```

## Dependencies

The widgets use the following packages:
- `flutter/material.dart`: Material Design components
- `cached_network_image`: Image caching
- `shimmer`: Shimmer loading effect
- `equatable`: Value equality (for domain entities)

## Notes

- All widgets follow Material Design guidelines
- Vietnamese language is used for user-facing text
- Widgets are designed to be reusable and composable
- Error handling is built into image loading widgets
- Animations enhance user experience without being distracting
