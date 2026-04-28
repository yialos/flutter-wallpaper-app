import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../browse/domain/entities/category.dart';
import '../providers/category_providers.dart';

/// Horizontal scrollable category filter widget
/// Requirements: 3.1, 3.2, 3.4
class CategoryFilterWidget extends ConsumerWidget {
  final String? selectedCategoryId;
  final Function(String?) onCategorySelected;

  const CategoryFilterWidget({
    super.key,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) => _buildCategoryList(context, categories),
      loading: () => const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<Category> categories) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: [
          // "All" option
          _CategoryChip(
            label: 'Tất cả',
            isSelected: selectedCategoryId == null,
            onTap: () => onCategorySelected(null),
          ),
          const SizedBox(width: 8),

          // Category chips
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _CategoryChip(
                label: category.name,
                isSelected: selectedCategoryId == category.id,
                onTap: () => onCategorySelected(category.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual category chip widget
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
