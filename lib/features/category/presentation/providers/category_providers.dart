import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../browse/domain/entities/category.dart';
import '../../../browse/domain/usecases/get_categories_use_case.dart';
import '../../../browse/presentation/providers/browse_providers.dart';

/// Provider for GetCategoriesUseCase
/// Requirements: 3.1, 3.2
final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

/// Provider for fetching categories
/// Requirements: 3.1, 3.2, 3.3
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final useCase = ref.watch(getCategoriesUseCaseProvider);
  return await useCase.execute();
});

/// State provider for selected category
/// Requirements: 3.2, 3.4
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
