# Wallpaper App 🖼️

Ứng dụng hình nền đa nền tảng được xây dựng với Flutter, hỗ trợ Android, iOS, Web và Desktop.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.11.1-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Tính năng

### 🎨 Core Features
- **Browse Wallpapers**: Duyệt hàng nghìn hình nền chất lượng cao
- **Search**: Tìm kiếm hình nền với debouncing thông minh
- **Categories**: Lọc theo 10+ danh mục khác nhau
- **Download**: Tải xuống hình nền với progress tracking
- **Set Wallpaper**: Đặt hình nền trực tiếp (Android, iOS, macOS, Windows)
- **Favorites**: Lưu hình nền yêu thích với Hive persistence
- **Collections**: Tạo và quản lý bộ sưu tập hình nền
- **Share**: Chia sẻ hình nền qua social media

### 🌐 Platform Support
- ✅ **Android** - Native wallpaper setting với WallpaperManager
- ✅ **iOS** - Save to Photos với instructions
- ✅ **Web** - Full-featured web app
- ✅ **macOS** - Native wallpaper setting với NSWorkspace
- ✅ **Windows** - PowerShell-based wallpaper setting
- ⚠️ **Linux** - Coming soon

### 🎯 Advanced Features
- **Offline Support**: Xem cached wallpapers khi offline
- **Dark Mode**: Light/Dark theme với system preference
- **Accessibility**: WCAG AA compliant, screen reader support
- **Performance**: 60 FPS scrolling, < 2s launch time
- **Cache Management**: Smart LRU cache với 500MB limit
- **Multi-Resolution**: Tự động chọn resolution phù hợp

## 📸 Screenshots

| Browse | Detail | Collections | Settings |
|--------|--------|-------------|----------|
| ![Browse](screenshots/browse.png) | ![Detail](screenshots/detail.png) | ![Collections](screenshots/collections.png) | ![Settings](screenshots/settings.png) |

## 🏗️ Architecture

Ứng dụng được xây dựng theo **Clean Architecture** với 3 layers:

```
lib/
├── core/                 # Core utilities và configuration
│   ├── config/          # App configuration
│   ├── error/           # Error handling
│   ├── network/         # Network layer
│   ├── theme/           # Theme configuration
│   └── utils/           # Utility classes
├── features/            # Feature modules
│   ├── browse/          # Browse wallpapers
│   ├── search/          # Search functionality
│   ├── category/        # Category filtering
│   ├── detail/          # Wallpaper detail
│   ├── download/        # Download management
│   ├── favorites/       # Favorites management
│   ├── collections/     # Collections feature
│   ├── share/           # Share functionality
│   └── wallpaper_setter/# Platform-specific wallpaper setting
└── shared/              # Shared widgets và utilities
```

### Layer Structure
```
Feature/
├── data/
│   ├── models/          # DTOs và entities
│   ├── repositories/    # Repository implementations
│   └── services/        # Data services
├── domain/
│   ├── entities/        # Domain models
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business logic
└── presentation/
    ├── notifiers/       # State management
    ├── pages/           # UI screens
    ├── widgets/         # UI components
    └── providers/       # Riverpod providers
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x
- Dart SDK 3.11.1+
- Android Studio / VS Code
- Xcode (for iOS/macOS)
- Visual Studio (for Windows)

### Installation

1. **Clone repository**
```bash
git clone https://github.com/yourusername/wallpaper_app.git
cd wallpaper_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run app**
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios

# macOS
flutter run -d macos

# Windows
flutter run -d windows
```

## 🔧 Configuration

### Unsplash API (Optional)
Để sử dụng real Unsplash API thay vì mock data:

1. Đăng ký tại [Unsplash Developers](https://unsplash.com/developers)
2. Tạo application và lấy Access Key
3. Update `lib/core/config/unsplash_config.dart`:
```dart
static const String accessKey = 'YOUR_ACCESS_KEY_HERE';
```

### Cache Settings
Cấu hình cache trong `lib/core/config/app_constants.dart`:
```dart
static const int maxCacheSize = 500 * 1024 * 1024; // 500MB
static const int maxCacheAge = 30; // 30 days
```

## 📦 Dependencies

### Core
- `flutter_riverpod` - State management
- `dio` - HTTP client
- `hive` - Local storage
- `cached_network_image` - Image caching

### UI
- `flutter_staggered_grid_view` - Masonry grid
- `shimmer` - Loading placeholders
- `share_plus` - Share functionality

### Platform
- `path_provider` - File system access
- `permission_handler` - Permission management
- `connectivity_plus` - Network monitoring

[See full list in pubspec.yaml](pubspec.yaml)

## 🧪 Testing

### Run Tests
```bash
# All tests
flutter test

# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test test/integration/

# Coverage
flutter test --coverage
```

### Test Structure
```
test/
├── unit/              # Unit tests
├── widget/            # Widget tests
├── integration/       # Integration tests
└── fixtures/          # Test data
```

## 🎨 Theming

### Custom Theme
```dart
// Light theme
ThemeData lightTheme = AppTheme.lightTheme;

// Dark theme
ThemeData darkTheme = AppTheme.darkTheme;

// Custom colors
ColorScheme customScheme = AccessibleColors.createLightColorScheme();
```

### Accessibility
- WCAG AA compliant colors
- Minimum 48x48 dp touch targets
- Screen reader support
- Keyboard navigation (Desktop/Web)

## 🌍 Localization

Hiện tại hỗ trợ:
- 🇻🇳 Tiếng Việt (default)

Để thêm ngôn ngữ mới:
1. Tạo file `lib/l10n/app_[locale].arb`
2. Run `flutter gen-l10n`
3. Update `MaterialApp` với `localizationsDelegates`

## 📱 Platform-Specific Features

### Android
- Direct wallpaper setting (home/lock/both)
- SET_WALLPAPER permission required
- Minimum SDK: 21 (Android 5.0)

### iOS
- Save to Photos library
- Photo library permission required
- Manual wallpaper setting instructions
- Minimum iOS: 12.0

### macOS
- Direct wallpaper setting for all screens
- No permissions required
- Minimum macOS: 10.14

### Windows
- PowerShell-based wallpaper setting
- No permissions required
- Minimum Windows: 10

### Web
- Download functionality only
- Manual wallpaper setting instructions
- Works on all modern browsers

## 🐛 Troubleshooting

### Common Issues

**Build errors**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Hive errors**
```bash
# Delete Hive boxes
rm -rf [app_directory]/hive_boxes/
```

**Cache issues**
- Clear cache in Settings page
- Or delete cache directory manually

**Permission errors**
- Check AndroidManifest.xml (Android)
- Check Info.plist (iOS)
- Grant permissions in device settings

## 📊 Performance

### Metrics
- **Launch Time**: < 2 seconds
- **Scrolling**: 58-60 FPS
- **Memory**: 80-100MB
- **Cache**: Max 500MB

### Optimization Tips
- Use RepaintBoundary for complex widgets
- Implement viewport-based loading
- Optimize image sizes
- Use const constructors

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Run `dart format` before committing
- Ensure `dart analyze` passes
- Add tests for new features

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.

## 👥 Authors

- **Your Name** - *Initial work*

## 🙏 Acknowledgments

- [Unsplash](https://unsplash.com/) - Image API
- [Picsum Photos](https://picsum.photos/) - Mock images
- [Flutter](https://flutter.dev/) - Framework
- [Riverpod](https://riverpod.dev/) - State management

## 📞 Support

- 📧 Email: support@wallpaperapp.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/wallpaper_app/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/wallpaper_app/discussions)

## 🗺️ Roadmap

### v1.1.0
- [ ] Real Unsplash API integration
- [ ] Image compression
- [ ] Progressive image loading
- [ ] Background sync
- [ ] Offline download queue

### v2.0.0
- [ ] User accounts
- [ ] Upload wallpapers
- [ ] Social features (likes, comments)
- [ ] Wallpaper of the day
- [ ] Push notifications
- [ ] Analytics

## 📈 Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

---

Made with ❤️ using Flutter
