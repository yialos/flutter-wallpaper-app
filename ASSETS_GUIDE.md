# App Assets Guide - Wallpaper App

Hướng dẫn tạo và chuẩn bị assets cho tất cả platforms.

---

## 📱 App Icon Requirements

### Android

#### Adaptive Icon (Recommended)
- **Foreground:** 108x108 dp (432x432 px @4x)
- **Background:** 108x108 dp (432x432 px @4x)
- **Safe Zone:** 66x66 dp (264x264 px @4x)

#### Legacy Icon
- **xxxhdpi:** 192x192 px
- **xxhdpi:** 144x144 px
- **xhdpi:** 96x96 px
- **hdpi:** 72x72 px
- **mdpi:** 48x48 px

#### Play Store
- **Feature Graphic:** 1024x500 px
- **Icon:** 512x512 px (PNG, 32-bit)
- **Screenshots:** 
  - Phone: 1080x1920 px (min), 1440x2560 px (recommended)
  - Tablet: 1536x2048 px (7-inch), 2048x2732 px (10-inch)
  - Minimum 2, maximum 8 screenshots

### iOS

#### App Icon
- **1024x1024 px** - App Store (PNG, no alpha)
- **180x180 px** - iPhone @3x
- **120x120 px** - iPhone @2x
- **167x167 px** - iPad Pro @2x
- **152x152 px** - iPad @2x
- **76x76 px** - iPad @1x

#### App Store
- **Screenshots:**
  - iPhone 6.7": 1290x2796 px
  - iPhone 6.5": 1242x2688 px
  - iPhone 5.5": 1242x2208 px
  - iPad Pro 12.9": 2048x2732 px
  - Minimum 3, maximum 10 screenshots per device

### Web

#### Favicon
- **favicon.ico:** 16x16, 32x32, 48x48 px (multi-size ICO)
- **favicon-16x16.png:** 16x16 px
- **favicon-32x32.png:** 32x32 px
- **apple-touch-icon.png:** 180x180 px

#### PWA Icons
- **192x192 px** - Standard
- **512x512 px** - High-res
- **maskable:** 196x196 px safe zone in 512x512 px

### Windows

#### App Icon
- **256x256 px** - Large
- **48x48 px** - Medium
- **32x32 px** - Small
- **16x16 px** - Tiny

#### Microsoft Store
- **Icon:** 300x300 px
- **Screenshots:** 1366x768 px (min), 1920x1080 px (recommended)
- **Hero Image:** 1920x1080 px

### macOS

#### App Icon
- **1024x1024 px** - App Store
- **512x512 px** - @2x
- **256x256 px** - @1x
- **128x128 px** - @2x
- **64x64 px** - @1x
- **32x32 px** - @2x
- **16x16 px** - @1x

#### Mac App Store
- **Screenshots:** 1280x800 px (min), 2880x1800 px (recommended)

### Linux

#### App Icon
- **512x512 px** - High-res
- **256x256 px** - Standard
- **128x128 px** - Medium
- **64x64 px** - Small
- **48x48 px** - Tiny
- **32x32 px** - Mini
- **16x16 px** - Micro

---

## 🎨 Design Guidelines

### App Icon Design

#### Concept
- **Theme:** Wallpaper/Image gallery
- **Style:** Modern, minimalist
- **Colors:** Vibrant, eye-catching

#### Design Ideas

**Option 1: Gallery Grid**
```
┌─────────────┐
│ ▢ ▢ ▢ │
│ ▢ ▢ ▢ │
│ ▢ ▢ ▢ │
└─────────────┘
```
- 3x3 grid of colorful squares
- Gradient background
- Represents wallpaper collection

**Option 2: Mountain Landscape**
```
┌─────────────┐
│    /\    │
│   /  \   │
│  /    \  │
└─────────────┘
```
- Stylized mountain silhouette
- Gradient sky (blue to orange)
- Represents nature wallpapers

**Option 3: Abstract Layers**
```
┌─────────────┐
│ ═══════ │
│  ═══════  │
│   ═══════   │
└─────────────┘
```
- Layered colorful shapes
- Depth effect
- Represents multiple wallpapers

#### Color Palette
- **Primary:** #6366F1 (Indigo)
- **Secondary:** #EC4899 (Pink)
- **Accent:** #F59E0B (Amber)
- **Background:** #FFFFFF (White) / #1F2937 (Dark)

#### Typography
- **Font:** SF Pro (iOS), Roboto (Android), Segoe UI (Windows)
- **No text in icon** (better for international markets)

---

## 🖼️ Splash Screen

### Android

#### splash.png
- **xxxhdpi:** 1440x2560 px
- **xxhdpi:** 1080x1920 px
- **xhdpi:** 720x1280 px
- **hdpi:** 480x800 px
- **mdpi:** 320x480 px

#### Design
```
┌─────────────────┐
│                 │
│                 │
│      [LOGO]     │
│   Wallpaper App │
│                 │
│                 │
└─────────────────┘
```
- Centered logo
- App name below logo
- Solid color or gradient background
- Loading indicator (optional)

### iOS

#### LaunchScreen.storyboard
- Use storyboard for adaptive sizing
- Centered logo and app name
- Matches app theme

### Web

#### index.html
```html
<style>
  .splash {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, #6366F1, #EC4899);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
  }
</style>
<div class="splash">
  <img src="logo.png" alt="Wallpaper App" />
</div>
```

---

## 📸 Screenshots Guide

### Content to Capture

#### Screenshot 1: Browse/Home
- Grid view of wallpapers
- Show variety of categories
- Clean, organized layout

#### Screenshot 2: Search
- Search bar with query
- Search results
- Relevant wallpapers

#### Screenshot 3: Categories
- Category filter chips
- Filtered results
- Category variety

#### Screenshot 4: Detail View
- Full-screen wallpaper
- Action buttons visible
- Wallpaper info

#### Screenshot 5: Favorites
- Favorites grid
- Heart icons visible
- Personal collection

#### Screenshot 6: Collections
- Collection cards
- Multiple collections
- Organization feature

#### Screenshot 7: Dark Mode
- Same view as Screenshot 1
- Dark theme enabled
- Contrast and readability

#### Screenshot 8: Download/Set
- Download progress
- Set wallpaper dialog
- Success state

### Screenshot Tips

#### Composition
- Use high-quality wallpapers
- Show real app functionality
- Avoid lorem ipsum text
- Use realistic data

#### Device Frames
- Use official device frames
- Match platform guidelines
- Consistent across screenshots

#### Annotations (Optional)
- Highlight key features
- Use arrows and callouts
- Keep text minimal
- Match brand colors

### Tools

#### Screenshot Capture
- **Android:** Android Studio Device Frame
- **iOS:** Xcode Simulator
- **Web:** Browser DevTools
- **Desktop:** Native screenshot tools

#### Editing Tools
- **Figma** - Design and mockups
- **Sketch** - macOS design tool
- **Adobe Photoshop** - Professional editing
- **Canva** - Quick templates
- **Shotsnapp** - Device frames
- **Mockuphone** - Device mockups

---

## 🎬 Promotional Materials

### Feature Graphic (Google Play)

#### Size
1024x500 px

#### Design
```
┌────────────────────────────────────────┐
│                                        │
│  [LOGO]  Wallpaper App                │
│          Thousands of Beautiful        │
│          Wallpapers                    │
│                                        │
│  [SCREENSHOT 1] [SCREENSHOT 2]        │
│                                        │
└────────────────────────────────────────┘
```

#### Elements
- App logo
- App name and tagline
- 2-3 app screenshots
- Key features text
- Download CTA (optional)

### Promo Video (Optional)

#### Duration
15-30 seconds

#### Script
1. **Intro (3s):** Logo animation
2. **Browse (5s):** Show wallpaper grid
3. **Search (5s):** Search and filter
4. **Download (5s):** Download and set wallpaper
5. **Features (7s):** Favorites, collections, share
6. **Outro (5s):** App name and CTA

#### Tools
- **Adobe After Effects** - Professional
- **iMovie** - macOS simple editing
- **DaVinci Resolve** - Free professional
- **Canva** - Quick video templates

---

## 📁 Asset Organization

### Folder Structure
```
assets/
├── icons/
│   ├── android/
│   │   ├── mipmap-mdpi/
│   │   ├── mipmap-hdpi/
│   │   ├── mipmap-xhdpi/
│   │   ├── mipmap-xxhdpi/
│   │   └── mipmap-xxxhdpi/
│   ├── ios/
│   │   └── AppIcon.appiconset/
│   ├── web/
│   │   ├── favicon.ico
│   │   ├── icon-192.png
│   │   └── icon-512.png
│   ├── windows/
│   │   └── app_icon.ico
│   ├── macos/
│   │   └── AppIcon.icns
│   └── linux/
│       └── icon.png
├── splash/
│   ├── android/
│   ├── ios/
│   └── web/
├── screenshots/
│   ├── android/
│   ├── ios/
│   ├── web/
│   └── desktop/
├── store/
│   ├── feature-graphic.png
│   ├── promo-video.mp4
│   └── descriptions.txt
└── source/
    ├── icon.svg
    ├── icon.psd
    └── splash.psd
```

---

## 🛠️ Asset Generation Tools

### Icon Generators

#### Online Tools
- **App Icon Generator** - https://appicon.co/
- **Icon Kitchen** - https://icon.kitchen/
- **MakeAppIcon** - https://makeappicon.com/
- **Favicon Generator** - https://realfavicongenerator.net/

#### CLI Tools
```bash
# Flutter Launcher Icons
flutter pub add dev:flutter_launcher_icons

# pubspec.yaml
flutter_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
  adaptive_icon_background: "#6366F1"
  adaptive_icon_foreground: "assets/icon/foreground.png"

# Generate
flutter pub run flutter_launcher_icons
```

### Splash Screen Generator

```bash
# Flutter Native Splash
flutter pub add dev:flutter_native_splash

# pubspec.yaml
flutter_native_splash:
  color: "#6366F1"
  image: assets/splash/splash.png
  android: true
  ios: true
  web: true

# Generate
flutter pub run flutter_native_splash:create
```

---

## ✅ Asset Checklist

### Before Submission

#### Android
- [ ] Adaptive icon (foreground + background)
- [ ] Legacy icons (all densities)
- [ ] Feature graphic (1024x500)
- [ ] App icon (512x512)
- [ ] Screenshots (min 2, max 8)
- [ ] Splash screen (all densities)

#### iOS
- [ ] App icon (all sizes)
- [ ] App Store icon (1024x1024)
- [ ] Screenshots (all required devices)
- [ ] Launch screen

#### Web
- [ ] Favicon (ICO + PNG)
- [ ] PWA icons (192, 512)
- [ ] Apple touch icon
- [ ] Manifest icons

#### Windows
- [ ] App icon (ICO, multiple sizes)
- [ ] Store icon (300x300)
- [ ] Screenshots (min 1)

#### macOS
- [ ] App icon (ICNS)
- [ ] App Store icon (1024x1024)
- [ ] Screenshots

#### Linux
- [ ] App icon (PNG, multiple sizes)
- [ ] Desktop entry icon

---

## 📝 Design Brief Template

### Project: Wallpaper App Icon

**Objective:** Create a modern, recognizable app icon

**Style:** Minimalist, vibrant, professional

**Colors:** 
- Primary: #6366F1 (Indigo)
- Secondary: #EC4899 (Pink)
- Accent: #F59E0B (Amber)

**Concept:** Gallery/Collection of beautiful images

**Deliverables:**
- Source file (SVG/PSD)
- All platform sizes
- Light and dark variants

**Timeline:** 1 week

**Budget:** $XXX

---

## 🎨 Design Resources

### Free Resources
- **Unsplash** - Free photos
- **Flaticon** - Free icons
- **Google Fonts** - Free fonts
- **Coolors** - Color palettes

### Paid Resources
- **Adobe Stock** - Premium images
- **Envato Elements** - Design assets
- **Creative Market** - Design resources

---

**Last Updated:** 26/04/2026  
**Version:** 1.0.0
