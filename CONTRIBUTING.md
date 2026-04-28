# Contributing to Wallpaper App

Thank you for your interest in contributing to Wallpaper App! This document provides guidelines and instructions for contributing.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Guidelines](#issue-guidelines)

## Code of Conduct

### Our Pledge
We are committed to providing a welcoming and inspiring community for all.

### Our Standards
- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites
- Flutter SDK 3.x
- Dart SDK 3.11.1+
- Git
- IDE (VS Code or Android Studio recommended)

### Setup Development Environment

1. **Fork the repository**
```bash
# Click "Fork" button on GitHub
```

2. **Clone your fork**
```bash
git clone https://github.com/YOUR_USERNAME/wallpaper_app.git
cd wallpaper_app
```

3. **Add upstream remote**
```bash
git remote add upstream https://github.com/ORIGINAL_OWNER/wallpaper_app.git
```

4. **Install dependencies**
```bash
flutter pub get
```

5. **Generate code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

6. **Run app**
```bash
flutter run -d chrome
```

## Development Workflow

### Branch Strategy
- `main` - Production-ready code
- `develop` - Development branch
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `hotfix/*` - Urgent fixes

### Creating a Feature Branch
```bash
# Update your fork
git checkout develop
git pull upstream develop

# Create feature branch
git checkout -b feature/amazing-feature
```

### Making Changes
1. Make your changes
2. Test thoroughly
3. Format code: `dart format .`
4. Analyze code: `dart analyze`
5. Run tests: `flutter test`
6. Commit changes

### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

**Examples:**
```bash
feat(browse): add infinite scroll pagination

fix(download): handle insufficient storage error

docs(readme): update installation instructions

test(search): add unit tests for search notifier
```

## Coding Standards

### Dart Style Guide
Follow [Effective Dart](https://dart.dev/guides/language/effective-dart):

#### Naming Conventions
```dart
// ✅ Good
class WallpaperRepository {}
const int maxCacheSize = 500;
void downloadWallpaper() {}

// ❌ Bad
class wallpaper_repository {}
const int MAX_CACHE_SIZE = 500;
void DownloadWallpaper() {}
```

#### Documentation
```dart
/// Fetches wallpapers from the API.
///
/// [page] - Page number (1-indexed)
/// [perPage] - Number of items per page
///
/// Returns a list of [Wallpaper] objects.
///
/// Throws [NetworkException] if the request fails.
Future<List<Wallpaper>> getWallpapers({
  required int page,
  required int perPage,
}) async {
  // Implementation
}
```

#### Code Organization
```dart
// ✅ Good: Organized imports
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/wallpaper.dart';
import '../domain/repositories/wallpaper_repository.dart';

// ❌ Bad: Unorganized imports
import '../domain/entities/wallpaper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
```

### Architecture Guidelines

#### Clean Architecture Layers
```
Presentation → Domain ← Data
```

**Rules:**
- Presentation depends on Domain
- Data depends on Domain
- Domain depends on nothing
- No circular dependencies

#### Example Structure
```dart
// Domain Layer (entities, repositories, use cases)
class Wallpaper {
  final String id;
  final String title;
  // ...
}

abstract class WallpaperRepository {
  Future<List<Wallpaper>> getWallpapers();
}

class GetWallpapersUseCase {
  final WallpaperRepository repository;
  
  Future<List<Wallpaper>> execute() => repository.getWallpapers();
}

// Data Layer (implementations)
class WallpaperRepositoryImpl implements WallpaperRepository {
  @override
  Future<List<Wallpaper>> getWallpapers() {
    // Implementation
  }
}

// Presentation Layer (UI, state management)
class WallpaperNotifier extends StateNotifier<WallpaperState> {
  final GetWallpapersUseCase useCase;
  
  Future<void> loadWallpapers() async {
    final wallpapers = await useCase.execute();
    state = state.copyWith(wallpapers: wallpapers);
  }
}
```

### State Management with Riverpod

#### Provider Types
```dart
// Simple value
final counterProvider = StateProvider<int>((ref) => 0);

// Async data
final wallpapersProvider = FutureProvider<List<Wallpaper>>((ref) async {
  return await repository.getWallpapers();
});

// Stream
final favoritesProvider = StreamProvider<List<Wallpaper>>((ref) {
  return repository.watchFavorites();
});

// Complex state
final wallpaperNotifierProvider = 
  StateNotifierProvider<WallpaperNotifier, WallpaperState>((ref) {
    return WallpaperNotifier(ref.read(getWallpapersUseCaseProvider));
  });
```

#### Best Practices
```dart
// ✅ Good: Use ref.read for one-time operations
void onButtonPressed() {
  ref.read(notifierProvider.notifier).doSomething();
}

// ✅ Good: Use ref.watch for reactive updates
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(stateProvider);
  return Text(state.value);
}

// ❌ Bad: Don't use ref.watch in callbacks
void onButtonPressed() {
  final state = ref.watch(stateProvider); // Wrong!
}
```

## Testing Guidelines

### Test Structure
```
test/
├── unit/              # Unit tests
│   ├── domain/
│   ├── data/
│   └── utils/
├── widget/            # Widget tests
│   └── features/
├── integration/       # Integration tests
└── fixtures/          # Test data
```

### Writing Unit Tests
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWallpaperRepository extends Mock implements WallpaperRepository {}

void main() {
  group('GetWallpapersUseCase', () {
    late MockWallpaperRepository repository;
    late GetWallpapersUseCase useCase;

    setUp(() {
      repository = MockWallpaperRepository();
      useCase = GetWallpapersUseCase(repository);
    });

    test('should return wallpapers from repository', () async {
      // Arrange
      final wallpapers = [Wallpaper(id: '1', title: 'Test')];
      when(() => repository.getWallpapers()).thenAnswer((_) async => wallpapers);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, wallpapers);
      verify(() => repository.getWallpapers()).called(1);
    });
  });
}
```

### Writing Widget Tests
```dart
void main() {
  testWidgets('WallpaperCard displays wallpaper info', (tester) async {
    // Arrange
    final wallpaper = Wallpaper(
      id: '1',
      title: 'Test Wallpaper',
      thumbnailUrl: 'https://example.com/image.jpg',
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: WallpaperCard(wallpaper: wallpaper),
      ),
    );

    // Assert
    expect(find.text('Test Wallpaper'), findsOneWidget);
  });
}
```

### Test Coverage
- Aim for >80% code coverage
- Focus on business logic
- Test edge cases
- Test error scenarios

### Running Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/unit/domain/usecases/get_wallpapers_use_case_test.dart

# With coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## Pull Request Process

### Before Submitting
- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] No merge conflicts
- [ ] Commits are clean and descriptive

### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests pass locally
```

### Review Process
1. Submit PR
2. Automated checks run
3. Code review by maintainers
4. Address feedback
5. Approval and merge

### After Merge
```bash
# Update your fork
git checkout develop
git pull upstream develop
git push origin develop

# Delete feature branch
git branch -d feature/amazing-feature
git push origin --delete feature/amazing-feature
```

## Issue Guidelines

### Bug Reports
Use the bug report template:

```markdown
**Describe the bug**
Clear description of the bug

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen

**Screenshots**
If applicable

**Environment:**
- Device: [e.g. iPhone 12]
- OS: [e.g. iOS 15.0]
- App Version: [e.g. 1.0.0]

**Additional context**
Any other information
```

### Feature Requests
Use the feature request template:

```markdown
**Is your feature request related to a problem?**
Clear description of the problem

**Describe the solution you'd like**
Clear description of what you want

**Describe alternatives you've considered**
Alternative solutions

**Additional context**
Any other information
```

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Riverpod Documentation](https://riverpod.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## Questions?

- 💬 [GitHub Discussions](https://github.com/yourusername/wallpaper_app/discussions)
- 📧 Email: dev@wallpaperapp.com

---

Thank you for contributing! 🎉
