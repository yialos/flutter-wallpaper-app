import 'package:equatable/equatable.dart';
import '../../domain/entities/collection.dart';

/// State for collection management
class CollectionState extends Equatable {
  final List<Collection> collections;
  final bool isLoading;
  final String? error;

  const CollectionState({
    this.collections = const [],
    this.isLoading = false,
    this.error,
  });

  CollectionState copyWith({
    List<Collection>? collections,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CollectionState(
      collections: collections ?? this.collections,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [collections, isLoading, error];
}
