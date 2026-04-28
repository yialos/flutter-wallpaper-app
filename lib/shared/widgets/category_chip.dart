import 'package:flutter/material.dart';
import 'package:wallpaper_app/core/utils/accessibility_utils.dart';
import 'package:wallpaper_app/features/browse/domain/entities/category.dart';

/// Chip widget for displaying and selecting categories
class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final semanticLabel = isSelected
        ? 'Danh mục ${category.name} đã chọn, ${category.wallpaperCount} hình nền'
        : 'Danh mục ${category.name}, ${category.wallpaperCount} hình nền';
    final semanticHint = isSelected
        ? 'Nhấn để bỏ chọn danh mục này'
        : 'Nhấn để lọc theo danh mục này';

    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (category.iconUrl != null) ...[
                // TODO: Add icon support when API provides icons
                // For now, use a placeholder icon
                Icon(
                  Icons.category,
                  size: 16,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
                const SizedBox(width: 6),
              ],
              Text(
                category.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[800],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              if (category.wallpaperCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    '${category.wallpaperCount}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).withTouchTarget();
  }
}

/// Simple text-only category chip for compact display
class SimpleCategoryChip extends StatelessWidget {
  final String categoryName;
  final bool isSelected;
  final VoidCallback onTap;

  const SimpleCategoryChip({
    super.key,
    required this.categoryName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final semanticLabel = isSelected
        ? 'Danh mục $categoryName đã chọn'
        : 'Danh mục $categoryName';
    final semanticHint = isSelected
        ? 'Nhấn để bỏ chọn danh mục này'
        : 'Nhấn để lọc theo danh mục này';

    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            categoryName,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ).withTouchTarget();
  }
}
