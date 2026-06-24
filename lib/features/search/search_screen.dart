import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/extensions/string_extensions.dart';
import '../../router/app_router.dart';
import 'providers/search_providers.dart';
import 'widgets/search_result_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSuggestions = false;

  static const _filterChips = ['all', 'movie', 'tv', 'anime', 'person'];

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    ref.read(searchQueryProvider.notifier).state = trimmed;
    ref.read(searchHistoryProvider.notifier).addQuery(trimmed);
    _showSuggestions = false;
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final searchType = ref.watch(searchTypeProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final trendingAsync = ref.watch(trendingSearchesProvider);
    final searchHistory = ref.watch(searchHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
            setState(() => _showSuggestions = value.trim().isNotEmpty);
          },
          onSubmitted: _onSubmit,
          textDirection: Directionality.of(context),
          decoration: InputDecoration(
            hintText: 'Search movies, TV, anime...',
            border: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
            hintStyle: TextStyle(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                      setState(() => _showSuggestions = false);
                    },
                  )
                : null,
          ),
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          if (_showSuggestions)
            _SuggestionsOverlay(
              query: query,
              onTap: _onSubmit,
            ),
          if (query.trim().isEmpty && searchHistory.isNotEmpty)
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 18,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Recent Searches',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      ref.read(searchHistoryProvider.notifier).clearAll();
                    },
                    icon: Icon(Icons.clear_all, size: 18),
                    label: Text('Clear'),
                  ),
                ],
              ),
            ),
          if (query.trim().isEmpty && searchHistory.isNotEmpty)
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
                itemCount: searchHistory.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = searchHistory[index];
                  return Chip(
                    label: Text(item),
                    deleteIcon: Icon(Icons.close, size: 16),
                    onDeleted: () {
                      ref.read(searchHistoryProvider.notifier).removeQuery(item);
                    },
                    onPressed: () {
                      _searchController.text = item;
                      _onSubmit(item);
                    },
                  );
                },
              ),
            ),
          if (query.trim().isEmpty && searchHistory.isEmpty)
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Trending',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          Expanded(
            child: query.trim().length < 2
                ? trendingAsync.when(
                    data: (trending) => _buildTrendingGrid(trending),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Failed to load trending')),
                  )
                : searchResultsAsync.when(
                    data: (results) {
                      if (results.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No results found for "$query"',
                                style: context.textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        );
                      }
                      return _buildResultsGrid(results, searchType);
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Search failed: $e')),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingGrid(List trending) {
    return GridView.builder(
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: 16,
        bottom: 16,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isDesktop ? 6 : context.isTablet ? 4 : 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: trending.length,
      itemBuilder: (context, index) {
        final item = trending[index];
        return SearchResultCard(
          media: item,
          onTap: () => context.push('/media/${item.id}'),
        );
      },
    );
  }

  Widget _buildResultsGrid(List results, String activeType) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
            children: _filterChips.map((chip) {
              final isSelected = activeType == chip;
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 8),
                child: FilterChip(
                  label: Text(chip.capitalize()),
                  selected: isSelected,
                  onSelected: (_) {
                    ref.read(searchTypeProvider.notifier).state = chip;
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsetsDirectional.only(
              start: 16,
              end: 16,
              bottom: 16,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isDesktop ? 6 : context.isTablet ? 4 : 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return SearchResultCard(
                media: item,
                onTap: () => context.push('/media/${item.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SuggestionsOverlay extends ConsumerWidget {
  final String query;
  final ValueChanged<String> onTap;

  const _SuggestionsOverlay({
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsAsync = ref.watch(searchSuggestionsProvider);

    return suggestionsAsync.when(
      data: (suggestions) {
        if (suggestions.isEmpty) return SizedBox.shrink();
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 16,
                  top: 8,
                  bottom: 4,
                ),
                child: Text(
                  'Suggestions',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              ...suggestions.map(
                (suggestion) => ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    suggestion,
                    style: context.textTheme.bodyMedium,
                  ),
                  onTap: () => onTap(suggestion),
                ),
              ),
              Divider(height: 1),
            ],
          ),
        );
      },
      loading: () => SizedBox.shrink(),
      error: (_, __) => SizedBox.shrink(),
    );
  }
}
