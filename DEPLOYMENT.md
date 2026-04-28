# Deployment Guide - Wallpaper App

Hướng dẫn build và deploy ứng dụng Wallpaper App cho tất cả platforms.

---

## 📋 Prerequisites

### Required Tools
- Flutter SDK 3.x
- Dart SDK 3.11.1+
- Android Studio (for Android)
- Xcode (for iOS/macOS)
- Visual Studio 2019+ (for Windows)
- Git

### Platform-Specific Requirements

#### Android
- Android SDK 21+ (Android 5.0+)
- Java JDK 11+
- Android signing key

#### iOS
- macOS with Xcode 14+
- iOS 12.0+
- Apple Developer Account
- Provisioning profiles

#### Web
- Modern web browser
- Web hosting service

#### Desktop
- Windows 10+
- macOS 10.14+
- Linux (Ubuntu 20.04+)

---

## 🚀 Build Instructions

### 1. Prepare Environment

```bash
# Clone repository
git clone https://github.com/yourusername/wallpaper_app.git
cd wallpaper_app

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Verify setup
flutter doctor -v
```

### 2. Configure App

#### Update App Configuration
Edit `lib/core/config/unsplash_config.dart`:
```dart
static const String accessKey = 'YOUR_PRODUCTION_API_KEY';
```

#### Update App Version
Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1  # Update version number
```

---

## 📱 Android Build

### Debug Build
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### Release Build (APK)
```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Release Build (App Bundle)
```bash
# Build release App Bundle (recommended for Play Store)
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### Signing Configuration

Create `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=YOUR_KEY_ALIAS
storeFile=YOUR_KEYSTORE_PATH
```

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### Generate Signing Key
```bash
keytool -genkey -v -keystore ~/wallpaper-app-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias wallpaper-app
```

---

## 🍎 iOS Build

### Debug Build
```bash
flutter build ios --debug
```

### Release Build
```bash
# Build release IPA
flutter build ipa --release

# Output: build/ios/ipa/wallpaper_app.ipa
```

### Xcode Configuration

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Update Bundle Identifier
4. Select Team (Apple Developer Account)
5. Configure Signing & Capabilities
6. Archive and upload to App Store Connect

### App Store Connect
1. Create app in App Store Connect
2. Upload IPA using Xcode or Transporter
3. Fill app information
4. Submit for review

---

## 🌐 Web Build

### Debug Build
```bash
flutter run -d chrome --web-renderer html
```

### Release Build
```bash
# Build release web
flutter build web --release --web-renderer html

# Output: build/web/
```

### Deployment Options

#### Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init hosting

# Deploy
firebase deploy --only hosting
```

#### Netlify
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy
netlify deploy --prod --dir=build/web
```

#### GitHub Pages
```bash
# Build
flutter build web --release --base-href "/wallpaper_app/"

# Copy to docs folder
cp -r build/web/* docs/

# Commit and push
git add docs/
git commit -m "Deploy to GitHub Pages"
git push
```

---

## 🖥️ Desktop Build

### Windows

#### Debug Build
```bash
flutter build windows --debug
```

#### Release Build
```bash
# Build release
flutter build windows --release

# Output: build/windows/runner/Release/
```

#### Create Installer (Optional)
Use Inno Setup or NSIS to create installer:

```iss
; Inno Setup Script
[Setup]
AppName=Wallpaper App
AppVersion=1.0.0
DefaultDirName={pf}\WallpaperApp
OutputDir=installer
OutputBaseFilename=WallpaperApp-Setup

[Files]
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs
```

### macOS

#### Debug Build
```bash
flutter build macos --debug
```

#### Release Build
```bash
# Build release
flutter build macos --release

# Output: build/macos/Build/Products/Release/wallpaper_app.app
```

#### Create DMG (Optional)
```bash
# Install create-dmg
brew install create-dmg

# Create DMG
create-dmg \
  --volname "Wallpaper App" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --app-drop-link 600 185 \
  "WallpaperApp-1.0.0.dmg" \
  "build/macos/Build/Products/Release/wallpaper_app.app"
```

### Linux

#### Debug Build
```bash
flutter build linux --debug
```

#### Release Build
```bash
# Build release
flutter build linux --release

# Output: build/linux/x64/release/bundle/
```

#### Create AppImage (Optional)
```bash
# Install appimagetool
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage

# Create AppImage structure
mkdir -p WallpaperApp.AppDir/usr/bin
cp -r build/linux/x64/release/bundle/* WallpaperApp.AppDir/usr/bin/

# Create AppImage
./appimagetool-x86_64.AppImage WallpaperApp.AppDir WallpaperApp-1.0.0-x86_64.AppImage
```

---

## 🔧 Build Configuration

### Environment Variables
```bash
# Production
export FLUTTER_ENV=production
export API_KEY=your_production_key

# Staging
export FLUTTER_ENV=staging
export API_KEY=your_staging_key
```

### Build Flavors (Optional)

#### Android
Edit `android/app/build.gradle`:
```gradle
android {
    flavorDimensions "environment"
    productFlavors {
        production {
            dimension "environment"
            applicationIdSuffix ""
        }
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
        }
    }
}
```

Build with flavor:
```bash
flutter build apk --flavor production --release
flutter build apk --flavor staging --release
```

---

## 📦 Distribution

### Android

#### Google Play Store
1. Create developer account ($25 one-time fee)
2. Create app in Play Console
3. Upload AAB file
4. Fill store listing
5. Submit for review

#### Alternative Stores
- Amazon Appstore
- Samsung Galaxy Store
- Huawei AppGallery

### iOS

#### App Store
1. Create developer account ($99/year)
2. Create app in App Store Connect
3. Upload IPA via Xcode/Transporter
4. Fill app information
5. Submit for review

### Web

#### Hosting Options
- Firebase Hosting
- Netlify
- Vercel
- GitHub Pages
- AWS S3 + CloudFront
- Google Cloud Storage

### Desktop

#### Windows
- Microsoft Store
- Direct download from website
- Chocolatey package manager

#### macOS
- Mac App Store
- Direct download from website
- Homebrew cask

#### Linux
- Snap Store
- Flathub
- AppImage
- Direct download

---

## 🧪 Testing Before Release

### Pre-Release Checklist
- [ ] All features tested on target platforms
- [ ] Performance benchmarks met
- [ ] No memory leaks
- [ ] Accessibility tested
- [ ] Error handling verified
- [ ] Offline mode tested
- [ ] API keys configured
- [ ] Version numbers updated
- [ ] Changelog updated
- [ ] Screenshots prepared
- [ ] App descriptions written
- [ ] Privacy policy ready

### Testing Commands
```bash
# Run tests
flutter test

# Run integration tests
flutter test integration_test/

# Analyze code
flutter analyze

# Check for outdated packages
flutter pub outdated
```

---

## 📊 Monitoring & Analytics

### Recommended Tools
- Firebase Analytics
- Sentry (error tracking)
- Google Analytics
- Mixpanel
- Amplitude

### Implementation
```dart
// Add to pubspec.yaml
dependencies:
  firebase_analytics: ^10.0.0
  sentry_flutter: ^7.0.0

// Initialize in main.dart
await SentryFlutter.init(
  (options) {
    options.dsn = 'YOUR_SENTRY_DSN';
  },
  appRunner: () => runApp(MyApp()),
);
```

---

## 🔄 CI/CD Setup

### GitHub Actions

Create `.github/workflows/build.yml`:
```yaml
name: Build and Deploy

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.x'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test
    
    - name: Build web
      run: flutter build web --release
    
    - name: Deploy to Firebase
      uses: FirebaseExtended/action-hosting-deploy@v0
      with:
        repoToken: '${{ secrets.GITHUB_TOKEN }}'
        firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
        channelId: live
```

---

## 📝 Release Notes Template

```markdown
# Version 1.0.0 - Initial Release

## New Features
- Browse thousands of high-quality wallpapers
- Search functionality with smart filtering
- Download wallpapers with progress tracking
- Set wallpapers directly on device
- Favorites management
- Collections/Albums
- Dark mode support
- Offline support

## Improvements
- Optimized performance (60 FPS scrolling)
- Reduced memory usage
- Faster app launch

## Bug Fixes
- Fixed image loading issues
- Fixed cache management
- Fixed offline mode

## Known Issues
- None

## Platform Support
- Android 5.0+
- iOS 12.0+
- Web (all modern browsers)
- Windows 10+
- macOS 10.14+
```

---

## 🆘 Troubleshooting

### Common Build Issues

#### Android
```bash
# Clean build
flutter clean
cd android && ./gradlew clean && cd ..
flutter pub get
flutter build apk --release
```

#### iOS
```bash
# Clean build
flutter clean
cd ios && pod deintegrate && pod install && cd ..
flutter build ios --release
```

#### Web
```bash
# Clear web cache
flutter clean
flutter pub get
flutter build web --release --web-renderer html
```

---

## 📞 Support

For deployment issues:
- GitHub Issues: https://github.com/yourusername/wallpaper_app/issues
- Email: dev@wallpaperapp.com
- Documentation: https://wallpaperapp.com/docs

---

**Last Updated:** 26/04/2026  
**Version:** 1.0.0
