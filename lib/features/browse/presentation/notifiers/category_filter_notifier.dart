import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/features/browse/domain/entities/entities.dart';
import 'package:wallpaper_app/features/browse/domain/usecases/get_categories_use_case.dart';
import 'package:wallpaper_app/features/browse/presentation/providers/browse_providers.dart';

/// State class for category filter
/// Requirements: 3.1, 3.2
class CategoryFilterState {
  final List<Category> categories;
  final String? selectedCategoryId;
  final bool isLoading;
  final String? error;

  const CategoryFilterState({
    this.categories = const [],
    this.selectedCategoryId,
    this.isLoading = false,
    this.error,
  });

  CategoryFilterState copyWith({
    List<Category>? categories,
    String? selectedCategoryId,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearSelection = false,
  }) {
    return CategoryFilterState(
      categories: categories ?? this.categories,
      selectedCategoryId: clearSelection
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  Category? get selectedCategory {
    if (selectedCategoryId == null) return null;
    try {
      return categories.firstWhere((cat) => cat.id == selectedCategoryId);
    } catch (_) {
      return null;
    }
  }
}

/// State notifier for category filtering
/// Requirements: 3.1, 3.2, 3.3, 3.4
class CategoryFilterNotifier extends StateNotifier<CategoryFilterState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryFilterNotifier(this._getCategoriesUseCase)
    : super(const CategoryFilterState());

  /// Load available categories
  /// Requirements: 3.1, 3.3
  Future<void> loadCategories() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final categories = await _getCategoriesUseCase.execute();

      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Select a category for filtering
  /// Requirements: 3.2, 3.4
  void selectCategory(String? categoryId) {
    if (categoryId == null) {
      state = state.copyWith(clearSelection: true);
    } else {
      state = state.copyWith(selectedCategoryId: categoryId);
    }
  }

  /// Clear category selection (show all)
  /// Requirements: 3.4
  void clearSelection() {
    state = state.copyWith(clearSelection: true);
  }

  /// Clear any error state
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for CategoryFilterNotifier
/// Requirements: 3.1, 3.2, 3.3, 3.4
final categoryFilterNotifierProvider =
    StateNotifierProvider<CategoryFilterNotifier, CategoryFilterState>((ref) {
      final getCategoriesUseCase = ref.watch(getCategoriesUseCaseProvider);
      return CategoryFilterNotifier(getCategoriesUseCase);
    });
