import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/providers/app_providers.dart';
import '../../core/shared/media_card.dart';
import '../../core/shared/horizontal_carousel.dart';
import '../../models/media_model.dart';
import 'providers/discover_providers.dart';
import 'widgets/filter_chip.dart';
import '../../l10n/l10n.dart';
// import 'widgets/filter_sheet.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  late PagingController<int, MediaModel> _pagingController;
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _lastSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, MediaModel>(firstPageKey: 1);
    _pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      final query = value.trim();
      if (query != _lastSearchQuery) {
        _lastSearchQuery = query;
        ref.read(discoverFilterProvider.notifier).setSearchQuery(
              query.isEmpty ? null : query,
            );
      }
    });
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
    final gridPadding = Spacing.gridPadding(screenWidth);
    final spacing = Spacing.gridSpacing(screenWidth);
    final cardWidth =
        (screenWidth - gridPadding * 2 - (columns - 1) * spacing) / columns;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.discover),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.filter_list),
          //   onPressed: () => _showFilterSheet(context),
          //   tooltip: 'Filters',
          // ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 4)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsDirectional.only(bottom: 8),
              child: _buildTabBar(filters),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsDirectional.only(bottom: 8),
              child: _buildSearchBar(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsDirectional.only(bottom: 8),
              child: _buildGenreChips(filters, genresAsync),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsDirectional.only(bottom: 8),
              child: _buildActiveFilters(filters),
            ),
          ),
          SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(Spacing.lg, 0, Spacing.lg, Spacing.lg),
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
                  id: item.id,
                  title: item.title,
                  posterUrl: AppConstants.mediaImageUrl(item.posterPath),
                  voteAverage: item.voteAverage,
                  mediaType: item.mediaType,
                  width: cardWidth,
                  onTap: () => _navigateToDetail(item),
                ).animate().fadeIn(
                      duration: 300.ms,
                      delay: (index % 20 * 30).ms,
                    ),
                firstPageProgressIndicatorBuilder: (_) =>
                    const Center(
                  child: Padding(
                    padding: EdgeInsets.all(Spacing.xxl),
                    child: CircularProgressIndicator(),
                  ),
                ),
                newPageProgressIndicatorBuilder: (_) =>
                    const Center(
                  child: Padding(
                    padding: EdgeInsets.all(Spacing.lg),
                    child: CircularProgressIndicator(),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => Center(
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(Spacing.section),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.movie_filter_outlined,
                          size: 64,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(height: Spacing.lg),
                        Text(
                          context.l10n.noResults,
                          style: context.textTheme.titleMedium,
                        ),
                        SizedBox(height: Spacing.sm),
                        Text(
                          context.l10n.tryAdjustingFilters,
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

  Widget _buildSearchBar() {
    final colorScheme = context.colorScheme;
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: context.l10n.searchMoviesTvAnime,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          prefixIcon: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: colorScheme.onSurfaceVariant),
                  onPressed: () {
                    _searchController.clear();
                    _lastSearchQuery = '';
                    ref.read(discoverFilterProvider.notifier).setSearchQuery(null);
                  },
                )
              : null,
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsetsDirectional.symmetric(vertical: Spacing.md),
        ),
        style: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }

  Widget _buildTabBar(DiscoverFilters filters) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg, vertical: 2),
      child: SegmentedButton<DiscoverMediaTab>(
        segments: [
          ButtonSegment(value: DiscoverMediaTab.movies, label: Text(context.l10n.movies)),
          ButtonSegment(value: DiscoverMediaTab.tv, label: Text(context.l10n.tvShows)),
          ButtonSegment(value: DiscoverMediaTab.anime, label: Text(context.l10n.anime)),
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
        return _GenreChipsCarousel(
          genres: genres,
          selectedGenreId: filters.genreId,
          onGenreTap: (genre) {
            if (filters.genreId == genre.id) {
              ref.read(discoverFilterProvider.notifier).setGenreId(null);
            } else {
              ref.read(discoverFilterProvider.notifier).setGenreId(genre.id);
            }
          },
        );
      },
      loading: () => SizedBox(
        height: 48,
        child: HorizontalCarousel(
          height: 48,
          itemCount: 8,
          separatorWidth: Spacing.sm,
          padding: EdgeInsetsDirectional.only(start: Spacing.lg, end: Spacing.lg),
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

    if (!hasActiveFilters) return const SizedBox(height: Spacing.sm);

    final theme = Theme.of(context);
    final chips = <Widget>[];

    if (filters.genreId != null) {
      final genres = ref.watch(genreListProvider).valueOrNull ?? [];
      final genre = genres.where((g) => g.id == filters.genreId).firstOrNull;
      chips.add(_buildActiveChip(
        genre != null ? 'Genre: ${genre.name}' : '#${filters.genreId}',
        theme,
      ));
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
      padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg, vertical: Spacing.xs),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: chips),
            ),
          ),
          const SizedBox(width: Spacing.sm),
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
      padding: EdgeInsetsDirectional.only(end: Spacing.sm),
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

  // void _showFilterSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) => const FilterSheet(),
  //   );
  // }

  void _navigateToDetail(MediaModel media) {
    context.push('/media/${media.mediaType.name}/${media.id}');
  }
}

class _GenreChipsCarousel extends StatefulWidget {
  final List<Genre> genres;
  final int? selectedGenreId;
  final ValueChanged<Genre> onGenreTap;

  const _GenreChipsCarousel({
    required this.genres,
    required this.selectedGenreId,
    required this.onGenreTap,
  });

  @override
  State<_GenreChipsCarousel> createState() => _GenreChipsCarouselState();
}

class _GenreChipsCarouselState extends State<_GenreChipsCarousel> {
  final _scrollController = ScrollController();
  bool _isDragging = false;
  double _dragStartScrollOffset = 0;
  double _dragStartGlobalX = 0;

  bool get _useGrabToScroll {
    if (kIsWeb) return true;
    if (!Platform.isAndroid && !Platform.isIOS) return true;
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _dragStartScrollOffset = _scrollController.offset;
    _dragStartGlobalX = details.globalPosition.dx;
    _isDragging = false;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final delta = isRtl
        ? details.globalPosition.dx - _dragStartGlobalX
        : _dragStartGlobalX - details.globalPosition.dx;
    if (!_isDragging && delta.abs() > 6) {
      setState(() => _isDragging = true);
    }
    if (!_isDragging) return;
    _scrollController.jumpTo(
      (_dragStartScrollOffset + delta).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
    );
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() > 50) {
      final target = (_scrollController.offset - velocity * 0.15).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        target,
        duration: Duration(
          milliseconds: (velocity.abs() * 0.5).toInt().clamp(100, 400),
        ),
        curve: Curves.easeOut,
      );
    }
    setState(() => _isDragging = false);
  }

  Widget _buildList() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.only(start: Spacing.lg, end: Spacing.lg),
        physics: _isDragging ? const NeverScrollableScrollPhysics() : null,
        itemCount: widget.genres.length,
        separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
        itemBuilder: (context, index) {
          final genre = widget.genres[index];
          return FilterChipWidget(
            label: genre.name,
            isSelected: widget.selectedGenreId == genre.id,
            onTap: () => widget.onGenreTap(genre),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_useGrabToScroll) return _buildList();

    return MouseRegion(
      cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.opaque,
        child: _buildList(),
      ),
    );
  }
}