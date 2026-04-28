import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/connectivity_providers.dart';
import '../../../../core/utils/edge_case_handler.dart';
import '../../../../shared/widgets/offline_indicator.dart';
import '../notifiers/search_notifier.dart' show searchNotifierProvider;
import '../widgets/search_bar_widget.dart';
import '../widgets/search_results_view.dart';

/// Search page for wallpapers
/// Requirements: 2.1, 2.2, 2.3, 2.5
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm hình nền'), elevation: 0),
      body: Column(
        children: [
          // Offline indicator
          const AnimatedOfflineIndicator(),

          // Search bar
          SearchBarWidget(
            controller: _searchController,
            enabled: isOnline,
            onSearch: (query) {
              if (!isOnline) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Không thể tìm kiếm khi offline'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              // Validate search query
              final validationError = EdgeCaseHandler.validateSearchQuery(
                query,
              );
              if (validationError != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(validationError),
                    duration: const Duration(seconds: 2),
                  ),
                );
                return;
              }

              // Sanitize and search
              final sanitizedQuery = EdgeCaseHandler.sanitizeSearchQuery(query);
              if (sanitizedQuery.isNotEmpty) {
                ref
                    .read(searchNotifierProvider.notifier)
                    .searchWallpapers(sanitizedQuery);
              } else {
                ref.read(searchNotifierProvider.notifier).clearSearch();
              }
            },
            onClear: () {
              _searchController.clear();
              ref.read(searchNotifierProvider.notifier).clearSearch();
            },
          ),

          // Offline message
          if (!isOnline && searchState.results.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Không thể tìm kiếm khi offline',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            // Search results
            Expanded(child: SearchResultsView(searchState: searchState)),
        ],
      ),
    );
  }
}
