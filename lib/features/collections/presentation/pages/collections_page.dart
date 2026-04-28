import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/collection_providers.dart';
import '../widgets/collection_card.dart';
import '../widgets/create_collection_dialog.dart';

/// Page displaying all collections
class CollectionsPage extends ConsumerStatefulWidget {
  const CollectionsPage({super.key});

  @override
  ConsumerState<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends ConsumerState<CollectionsPage> {
  @override
  void initState() {
    super.initState();
    // Load collections on page init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(collectionNotifierProvider.notifier).loadCollections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final collectionsAsync = ref.watch(collectionsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bộ Sưu Tập'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCollectionDialog(context),
            tooltip: 'Tạo bộ sưu tập mới',
          ),
        ],
      ),
      body: collectionsAsync.when(
        data: (collections) {
          if (collections.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(collectionNotifierProvider.notifier)
                  .loadCollections();
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getCrossAxisCount(context),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: collections.length,
              itemBuilder: (context, index) {
                return CollectionCard(collection: collections[index]);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Lỗi: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(collectionNotifierProvider.notifier)
                      .loadCollections();
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateCollectionDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Tạo mới'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.collections_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Chưa có bộ sưu tập nào',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Tạo bộ sưu tập để tổ chức hình nền',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateCollectionDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Tạo bộ sưu tập đầu tiên'),
          ),
        ],
      ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateCollectionDialog(),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 2;
  }
}
