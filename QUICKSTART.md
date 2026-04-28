# Quick Start Guide - Wallpaper App

## 🚀 Chạy App Trong 5 Phút

### Bước 1: Clone Repository (nếu có)
```bash
git clone <repository-url>
cd wallpaper_app
```

### Bước 2: Install Dependencies
```bash
flutter pub get
```

### Bước 3: Run App

#### Web (Khuyến nghị cho test nhanh)
```bash
flutter run -d chrome
# Hoặc
flutter run -d edge
```

#### Android
```bash
flutter run -d android
```

#### iOS (chỉ trên macOS)
```bash
flutter run -d ios
```

#### Desktop
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

---

## ✅ App Đã Chạy!

Bạn sẽ thấy:
1. **Home Screen** - Grid view với 100 wallpapers
2. **Search Icon** - Tap để search
3. **Category Filter** - Scroll ngang để filter
4. **Bottom Navigation** - Home, Favorites, Settings

---

## 🎮 Thử Các Tính Năng

### Browse Wallpapers
1. Scroll xuống để load thêm wallpapers (infinite scroll)
2. Pull-to-refresh để reload
3. Tap vào wallpaper để xem detail

### Search
1. Tap search icon ở top-right
2. Nhập từ khóa (VD: "nature", "city")
3. Kết quả hiện ra sau 500ms (debounced)

### Category Filter
1. Scroll ngang category bar ở top
2. Tap category để filter
3. Tap "Tất cả" để clear filter

### Wallpaper Detail
1. Tap vào wallpaper
2. Pinch to zoom (0.5x - 4x)
3. Pan để di chuyển
4. Tap action buttons:
   - ⬇️ Download
   - 🖼️ Set Wallpaper (Web: download only)
   - ❤️ Favorite
   - 📤 Share

### Favorites
1. Tap heart icon trên wallpaper
2. Go to Favorites tab (bottom nav)
3. View all favorited wallpapers
4. Tap "Xóa tất cả" để clear all

### Settings
1. Go to Settings tab (bottom nav)
2. Toggle dark mode
3. View cache size
4. Clear cache nếu cần

### Offline Mode
1. Disconnect internet
2. App vẫn hoạt động với cached content
3. Offline indicator hiện ở top
4. Search bị disable khi offline

---

## 🐛 Troubleshooting

### App không chạy?
```bash
# Check Flutter
flutter doctor -v

# Clean và rebuild
flutter clean
flutter pub get
flutter run
```

### Build errors?
```bash
# Check analyzer
dart analyze

# Format code
dart format lib
```

### Web không load?
```bash
# Try different browser
flutter run -d chrome
flutter run -d edge

# Check port
flutter run -d chrome --web-port 8080
```

### Android build fails?
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

---

## 📱 Test Trên Device

### Android
```bash
# Enable USB debugging trên phone
# Connect phone qua USB
flutter devices
flutter run -d <device-id>
```

### iOS
```bash
# Connect iPhone qua USB
flutter devices
flutter run -d <device-id>
```

---

## 🔧 Development Tips

### Hot Reload
Khi app đang chạy:
- Press `r` - Hot reload (fast)
- Press `R` - Hot restart (slower, full restart)
- Press `q` - Quit

### Debug Mode
```bash
# Run với debug mode (default)
flutter run

# Run với profile mode (performance testing)
flutter run --profile

# Run với release mode (production)
flutter run --release
```

### View Logs
```bash
# Flutter logs
flutter logs

# Android logs
adb logcat

# iOS logs
idevicesyslog
```

---

## 🎨 Customize

### Change Theme Colors
Edit `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryColor = Colors.blue; // Change this
```

### Change Mock Data
Edit `lib/features/browse/data/datasources/mock_wallpaper_datasource.dart`

### Add More Categories
Edit `lib/features/browse/data/datasources/mock_wallpaper_datasource.dart`:
```dart
static List<CategoryDTO> getMockCategories() {
  return [
    // Add your categories here
  ];
}
```

---

## 📚 Next Steps

1. ✅ App chạy thành công
2. 📖 Đọc [README.md](README.md) để hiểu architecture
3. 🚀 Đọc [DEPLOYMENT.md](DEPLOYMENT.md) để deploy
4. 🔍 Explore code trong `lib/` folder
5. 🛠️ Customize theo ý bạn!

---

## 💡 Pro Tips

1. **Use Web for fast development** - Hot reload nhanh nhất
2. **Use Chrome DevTools** - Debug performance
3. **Check dart analyze** - Trước khi commit
4. **Format code** - `dart format lib` trước khi commit
5. **Test offline mode** - Disconnect internet và test

---

## 🆘 Need Help?

- Check [README.md](README.md) - Full documentation
- Check [DEPLOYMENT.md](DEPLOYMENT.md) - Deployment guide
- Run `flutter doctor` - Check setup
- Run `dart analyze` - Check code issues

---

**Happy Coding! 🎉**
