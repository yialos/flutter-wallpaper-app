import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wallpaper_app/features/browse/domain/entities/wallpaper.dart';
import '../../domain/entities/collection.dart';
import '../providers/collection_providers.dart';
import 'create_collection_dialog.dart';

/// Bottom sheet for adding wallpaper to collection
class AddToCollectionBottomSheet extends ConsumerStatefulWidget {
  final Wallpaper wallpaper;

  const AddToCollectionBottomSheet({super.key, required this.wallpaper});

  @override
  ConsumerState<AddToCollectionBottomSheet> createState() =>
      _AddToCollectionBottomSheetState();
}

class _AddToCollectionBottomSheetState
    extends ConsumerState<AddToCollectionBottomSheet> {
  final Set<String> _processingCollections = {};

  @override
  void initState() {
    super.initState();
    // Load collections
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(collectionNotifierProvider.notifier).loadCollections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final collectionsAsync = ref.watch(collectionsStreamProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Thêm vào bộ sưu tập',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Collections list
            Expanded(
              child: collectionsAsync.when(
                data: (collections) {
                  if (collections.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: collections.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildCreateNewTile(context);
                      }

                      final collection = collections[index - 1];
                      final isInCollection = collection.containsWallpaper(
                        widget.wallpaper.id,
                      );
                      final isProcessing = _processingCollections.contains(
                        collection.id,
                      );

                      return _buildCollectionTile(
                        context,
                        collection,
                        isInCollection,
                        isProcessing,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Lỗi: $error')),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.collections_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('Chưa có bộ sưu tập nào'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Tạo bộ sưu tập đầu tiên'),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateNewTile(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: const Text('Tạo bộ sưu tập mới'),
      onTap: () => _showCreateDialog(context),
    );
  }

  Widget _buildCollectionTile(
    BuildContext context,
    Collection collection,
    bool isInCollection,
    bool isProcessing,
  ) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: collection.coverImageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  collection.coverImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.collections_outlined),
                ),
              )
            : const Icon(Icons.collections_outlined),
      ),
      title: Text(collection.name),
      subtitle: Text('${collection.wallpaperCount} hình nền'),
      trailing: isProcessing
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Checkbox(
              value: isInCollection,
              onChanged: (value) =>
                  _toggleWallpaper(collection, isInCollection),
            ),
      onTap: () => _toggleWallpaper(collection, isInCollection),
    );
  }

  Future<void> _toggleWallpaper(
    Collection collection,
    bool isCurrentlyInCollection,
  ) async {
    setState(() {
      _processingCollections.add(collection.id);
    });

    try {
      if (isCurrentlyInCollection) {
        // Remove from collection
        await ref
            .read(removeWallpaperFromCollectionUseCaseProvider)
            .execute(
              collectionId: collection.id,
              wallpaperId: widget.wallpaper.id,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã xóa khỏi "${collection.name}"'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        // Add to collection
        await ref
            .read(addWallpaperToCollectionUseCaseProvider)
            .execute(
              collectionId: collection.id,
              wallpaperId: widget.wallpaper.id,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã thêm vào "${collection.name}"'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }

      // Reload collections to update UI
      await ref.read(collectionNotifierProvider.notifier).loadCollections();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _processingCollections.remove(collection.id);
        });
      }
    }
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateCollectionDialog(),
    );
  }
}
