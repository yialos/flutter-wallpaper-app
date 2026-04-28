import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for getting all available categories
/// Requirements: 3.1, 3.2, 3.3, 3.4
class GetCategoriesUseCase {
  final CategoryRepository _repository;

  const GetCategoriesUseCase(this._repository);

  /// Execute the use case to get all categories
  ///
  /// Returns list of categories
  Future<List<Category>> execute() async {
    return await _repository.getCategories();
  }
}
