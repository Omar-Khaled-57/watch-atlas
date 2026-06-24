import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/providers/app_providers.dart';
import '../../core/shared/media_card.dart';
import '../../models/media_model.dart';
import 'providers/discover_providers.dart';
import 'widgets/filter_chip.dart';
import 'widgets/filter_sheet.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  late PagingController<int, MediaModel> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, MediaModel>(firstPageKey: 1);
    _pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final filters = ref.read(discoverFilterProvider);
      final anilist = ref.read(anilistServiceProvider);
      final items = await fetchDiscoverPage(
        page: pageKey,
        filters: filters,
        anilist: anilist,
      );
      final isLastPage = items.length < 20;
      if (isLastPage) {
        _pagingController.appendLastPage(items);
      } else {
        _pagingController.appendPage(items, pageKey + 1);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  void _onFilterChanged() {
    _pagingController.refresh();
  }

  int _gridColumns(double width) {
    if (width >= 1024) return 7;
    if (width >= 768) return 5;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(discoverFilterProvider);
    final genresAsync = ref.watch(genreListProvider);

    ref.listen<DiscoverFilters>(discoverFilterProvider, (prev, next) {
      if (prev != next) _onFilterChanged();
    });

    final columns = _gridColumns(context.screenWidth);
    final screenWidth = context.screenWidth;
    final gridPadding = 32.0;
    final spacing = 8.0;
    final cardWidth =
        (screenWidth - gridPadding - (columns - 1) * spacing) / columns;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
            tooltip: 'Filters',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildTabBar(filters),
          ),
          SliverToBoxAdapter(
            child: _buildGenreChips(filters, genresAsync),
          ),
          SliverToBoxAdapter(
            child: _buildActiveFilters(filters),
          ),
          SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
            sliver: PagedSliverGrid<int, MediaModel>(
              pagingController: _pagingController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 0.65,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              builderDelegate: PagedChildBuilderDelegate<MediaModel>(
                itemBuilder: (context, item, index) => MediaCard(
                  media: item,
                  width: cardWidth,
                  onTap: () => _navigateToDetail(item),
                ).animate().fadeIn(
                      duration: 300.ms,
                      delay: (index % 20 * 30).ms,
                    ),
                firstPageProgressIndicatorBuilder: (_) =>
                    const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                newPageProgressIndicatorBuilder: (_) =>
                    const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => Center(
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(48),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.movie_filter_outlined,
                          size: 64,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: context.textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(DiscoverFilters filters) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<DiscoverMediaTab>(
        segments: const [
          ButtonSegment(value: DiscoverMediaTab.movies, label: Text('Movies')),
          ButtonSegment(value: DiscoverMediaTab.tv, label: Text('TV Shows')),
          ButtonSegment(value: DiscoverMediaTab.anime, label: Text('Anime')),
        ],
        selected: {filters.tab},
        onSelectionChanged: (selected) {
          ref.read(discoverFilterProvider.notifier).setTab(selected.first);
        },
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenreChips(
    DiscoverFilters filters,
    AsyncValue<List<Genre>> genresAsync,
  ) {
    return genresAsync.when(
      data: (genres) {
        if (genres.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.only(start: 16, end: 16),
            itemCount: genres.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final genre = genres[index];
              return FilterChipWidget(
                label: genre.name,
                isSelected: filters.genreId == genre.id,
                onTap: () {
                  if (filters.genreId == genre.id) {
                    ref
                        .read(discoverFilterProvider.notifier)
                        .setGenreId(null);
                  } else {
                    ref
                        .read(discoverFilterProvider.notifier)
                        .setGenreId(genre.id);
                  }
                },
              );
            },
          ),
        );
      },
      loading: () => SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsDirectional.only(start: 16, end: 16),
          itemCount: 8,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, __) => Container(
            width: 80,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildActiveFilters(DiscoverFilters filters) {
    final hasActiveFilters = filters.genreId != null ||
        filters.country != null ||
        filters.yearFrom != null ||
        filters.yearTo != null ||
        filters.ratingFrom != null ||
        filters.ratingTo != null;

    if (!hasActiveFilters) return const SizedBox(height: 8);

    final theme = Theme.of(context);
    final chips = <Widget>[];

    if (filters.genreId != null) {
      chips.add(_buildActiveChip('Genre: #${filters.genreId}', theme));
    }
    if (filters.country != null) {
      chips.add(_buildActiveChip('Country: ${filters.country}', theme));
    }
    if (filters.yearFrom != null || filters.yearTo != null) {
      chips.add(_buildActiveChip(
        'Year: ${filters.yearFrom ?? "..."}-${filters.yearTo ?? "..."}',
        theme,
      ));
    }
    if (filters.ratingFrom != null || filters.ratingTo != null) {
      chips.add(_buildActiveChip(
        'Rating: ${filters.ratingFrom?.toStringAsFixed(1) ?? "0"}-${filters.ratingTo?.toStringAsFixed(1) ?? "10"}',
        theme,
      ));
    }

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: chips),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () =>
                ref.read(discoverFilterProvider.notifier).clearAll(),
            child: Icon(Icons.close, size: 18, color: theme.colorScheme.error),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChip(String label, ThemeData theme) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 8),
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterSheet(),
    );
  }

  void _navigateToDetail(MediaModel media) {
    Navigator.of(context).pushNamed('/media/${media.id}');
  }
}
