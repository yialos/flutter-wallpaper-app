import 'package:equatable/equatable.dart';

/// Generic class for paginated results
class PaginatedResult<T> extends Equatable {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });

  /// Create an empty paginated result
  factory PaginatedResult.empty() {
    return const PaginatedResult(
      items: [],
      currentPage: 0,
      totalPages: 0,
      hasMore: false,
    );
  }

  /// Create a copy of this result with updated fields
  PaginatedResult<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return PaginatedResult<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [items, currentPage, totalPages, hasMore];
}
