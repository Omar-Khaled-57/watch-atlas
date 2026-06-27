import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/shared/horizontal_carousel.dart';
import '../../models/user_media_model.dart';
import '../tracking/providers/tracking_providers.dart';
import '../../l10n/l10n.dart';
import 'providers/lists_providers.dart';

enum _ViewMode { grid, list }

class AllItemsScreen extends ConsumerStatefulWidget {
  const AllItemsScreen({super.key});

  @override
  ConsumerState<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends ConsumerState<AllItemsScreen> {
  _ViewMode _viewMode = _ViewMode.grid;
  String _categoryFilter = 'all';
  String _statusFilter = 'all';

  final _statuses = ['all', 'watching', 'completed', 'planToWatch', 'onHold', 'dropped'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final itemsAsync = ref.watch(allListItemsProvider);
    final userMediaAsync = ref.watch(userMediaProvider);
    final listsAsync = ref.watch(userListsProvider);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.allCollections)),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(context.l10n.failedToLoadItems, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error))),
        data: (items) {
          final userMedia = userMediaAsync.valueOrNull ?? [];
          final lists = listsAsync.valueOrNull ?? [];
          final categories = _extractCategories(items);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildCover(items.length, colorScheme, textTheme)),
              SliverToBoxAdapter(child: _buildMeta(items.length, lists.length, colorScheme, textTheme)),
              SliverToBoxAdapter(child: _buildCategoryTabs(categories, colorScheme, textTheme)),
              SliverToBoxAdapter(child: _buildStatusChips(colorScheme, textTheme)),
              SliverToBoxAdapter(child: _buildFilterToolbar(items.length, colorScheme, textTheme)),
              _buildItemsGrid(items, userMedia, isDesktop, isTablet, colorScheme, textTheme),
              const SliverPadding(padding: EdgeInsetsDirectional.only(bottom: 80)),
            ],
          );
        },
      ),
    );
  }

  List<String> _extractCategories(List<Map<String, dynamic>> items) {
    final cats = items.map((i) => i['media_type'] as String? ?? 'unknown').toSet();
    final ordered = <String>[];
    if (cats.contains('tv')) ordered.add(context.l10n.tvShows);
    if (cats.contains('movie')) ordered.add(context.l10n.movies);
    if (cats.contains('anime')) ordered.add(context.l10n.anime);
    ordered.addAll(cats.where((c) => c != 'tv' && c != 'movie' && c != 'anime').map((c) => c[0].toUpperCase() + c.substring(1)));
    return ordered;
  }

  Widget _buildCover(int totalItems, ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(Icons.collections_bookmark_rounded, size: 72, color: Colors.white.withValues(alpha: 0.15)),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.allCollections,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                    const SizedBox(height: Spacing.xs),
                  Text(
                    '${totalItems == 1 ? '$totalItems ${context.l10n.item}' : '$totalItems ${context.l10n.items}'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeta(int totalItems, int listCount, ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 14, 20, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _chip(Icons.collections_bookmark_rounded, '${context.l10n.across} $listCount list${listCount == 1 ? '' : 's'}', colorScheme, textTheme),
            const SizedBox(width: 6),
            _chip(Icons.movie_outlined, '${totalItems == 1 ? '$totalItems ${context.l10n.item}' : '$totalItems ${context.l10n.items}'}', colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(List<String> categories, ColorScheme colorScheme, TextTheme textTheme) {
    if (categories.isEmpty) return const SizedBox.shrink();
    final all = ['all', ...categories];
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 0, 4),
      child: SizedBox(
        height: 36,
        child: HorizontalCarousel(
          height: 36,
          itemCount: all.length,
          separatorWidth: 6,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final c = all[index];
            final isSelected = _categoryFilter == c;
            return FilterChip(
              label: Text(c == 'all' ? context.l10n.allFilter : c, style: textTheme.labelMedium?.copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
              selected: isSelected,
              onSelected: (_) => setState(() => _categoryFilter = c),
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              selectedColor: colorScheme.primaryContainer,
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusChips(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 0, 0),
      child: SizedBox(
        height: 32,
        child: HorizontalCarousel(
          height: 32,
          itemCount: _statuses.length,
          separatorWidth: 6,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final s = _statuses[index];
            final isSelected = _statusFilter == s;
            final label = s == 'all' ? context.l10n.allFilter : switch (s) {
              'watching' => context.l10n.watching,
              'completed' => context.l10n.completed,
              'planToWatch' => context.l10n.planToWatch,
              'onHold' => context.l10n.onHold,
              'dropped' => context.l10n.dropped,
              'rewatching' => context.l10n.rewatching,
              _ => s,
            };
            return FilterChip(
              label: Text(label, style: textTheme.labelSmall?.copyWith(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
              selected: isSelected,
              onSelected: (_) => setState(() => _statusFilter = s),
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              selectedColor: colorScheme.secondaryContainer,
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterToolbar(int totalItems, ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
      child: Row(
        children: [
          Text(context.l10n.itemCount(totalItems), style: textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          const Spacer(),
          IconButton(
            icon: Icon(_viewMode == _ViewMode.grid ? Icons.view_list_rounded : Icons.grid_view_rounded, size: 20),
            tooltip: context.l10n.toggleView,
            onPressed: () => setState(() => _viewMode = _viewMode == _ViewMode.grid ? _ViewMode.list : _ViewMode.grid),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsGrid(
    List<Map<String, dynamic>> items,
    List<UserMediaModel> userMedia,
    bool isDesktop,
    bool isTablet,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    var filtered = items.where((item) {
      if (_categoryFilter != 'all' && !_matchesCategory(item, _categoryFilter)) return false;
      if (_statusFilter == 'all') return true;
      final um = userMedia.where((u) => u.mediaId == (item['media_id'] as int)).firstOrNull;
      return um?.status.name == _statusFilter;
    }).toList();

    if (filtered.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 48, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: Spacing.md),
              Text(context.l10n.noItemsMatch, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      );
    }

    final crossAxisCount = isDesktop ? 6 : isTablet ? 5 : 3;

    if (_viewMode == _ViewMode.grid) {
      return SliverPadding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.6,
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => _GridTile(
              item: filtered[index],
              userMedia: userMedia,
              colorScheme: colorScheme,
              textTheme: textTheme,
              onTap: () {
                final item = filtered[index];
                final mediaData = item['media'] as Map<String, dynamic>?;
                final type = mediaData?['media_type'] as String? ?? item['media_type'] as String? ?? 'movie';
                context.push('/media/$type/${item['media_id']}');
              },
            ),
            childCount: filtered.length,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _ListTile(
            item: filtered[index],
            userMedia: userMedia,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onTap: () {
              final item = filtered[index];
              final mediaData = item['media'] as Map<String, dynamic>?;
              final type = mediaData?['media_type'] as String? ?? item['media_type'] as String? ?? 'movie';
              context.push('/media/$type/${item['media_id']}');
            },
          ),
          childCount: filtered.length,
        ),
      ),
    );
  }

  bool _matchesCategory(Map<String, dynamic> item, String category) {
    final type = item['media_type'] as String?;
    if (category == context.l10n.tvShows) return type == 'tv';
    if (category == context.l10n.movies) return type == 'movie';
    if (category == context.l10n.anime) return type == 'anime';
    return true;
  }

  Widget _chip(IconData icon, String label, ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
            horizontal: Spacing.sm, vertical: Spacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(label, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _GridTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<UserMediaModel> userMedia;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _GridTile({
    required this.item,
    required this.userMedia,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaId = item['media_id'] as int;
    final um = userMedia.where((u) => u.mediaId == mediaId).firstOrNull;
    final mediaData = item['media'] as Map<String, dynamic>?;
    final title = mediaData?['title'] as String? ?? context.l10n.mediaWithId(mediaId.toString());
    final posterPath = mediaData?['poster_path'] as String?;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: posterPath != null
                  ? CachedNetworkImage(
                      imageUrl: posterPath.posterUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Center(child: Icon(Icons.movie_outlined, size: 32, color: colorScheme.onSurfaceVariant)),
                      ),
                    )
                  : Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(child: Icon(Icons.movie_outlined, size: 32, color: colorScheme.onSurfaceVariant)),
                    ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(6, 4, 6, 4),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (um != null)
              Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 3),
                color: colorScheme.surfaceContainerLow,
                child: Row(
                  children: [
                    _statusDot(um.status.name),
                    const SizedBox(width: Spacing.xs),
                    Expanded(
                      child: Text(
                        switch (um.status.name) {
                          'watching' => context.l10n.watching,
                          'completed' => context.l10n.completed,
                          'planToWatch' => context.l10n.planToWatch,
                          'onHold' => context.l10n.onHold,
                          'dropped' => context.l10n.dropped,
                          'rewatching' => context.l10n.rewatching,
                          _ => um.status.name,
                        },
                        style: textTheme.labelSmall?.copyWith(fontSize: 9),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statusDot(String status) {
    final color = switch (status) {
      'watching' => const Color(0xFF4CAF50),
      'completed' => const Color(0xFF2196F3),
      'planToWatch' => const Color(0xFF9C27B0),
      'onHold' => const Color(0xFFFF9800),
      'dropped' => const Color(0xFFF44336),
      _ => colorScheme.onSurfaceVariant,
    };
    return Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

class _ListTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final List<UserMediaModel> userMedia;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _ListTile({
    required this.item,
    required this.userMedia,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaId = item['media_id'] as int;
    final note = item['note'] as String?;
    final um = userMedia.where((u) => u.mediaId == mediaId).firstOrNull;
    final mediaData = item['media'] as Map<String, dynamic>?;
    final title = mediaData?['title'] as String? ?? context.l10n.mediaWithId(mediaId.toString());
    final posterPath = mediaData?['poster_path'] as String?;
    final mediaType = mediaData?['media_type'] as String? ?? item['media_type'] as String? ?? 'movie';

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: const EdgeInsetsDirectional.only(bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
                child: Container(
                  width: 56,
                  height: 72,
                  color: colorScheme.surfaceContainerHighest,
                  child: posterPath != null
                      ? CachedNetworkImage(
                          imageUrl: posterPath.posterUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Icon(Icons.movie_outlined, size: 24, color: colorScheme.onSurfaceVariant),
                        )
                      : Center(child: Icon(Icons.movie_outlined, size: 24, color: colorScheme.onSurfaceVariant)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (note != null && note.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(note, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                            borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
                          ),
                          child: Text(mediaType.toUpperCase(), style: textTheme.labelSmall?.copyWith(fontSize: 9, color: colorScheme.onPrimaryContainer)),
                        ),
                        if (um != null) ...[
                            const SizedBox(width: Spacing.sm),
                          _statusDot(um.status.name),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            switch (um.status.name) {
                              'watching' => context.l10n.watching,
                              'completed' => context.l10n.completed,
                              'planToWatch' => context.l10n.planToWatch,
                              'onHold' => context.l10n.onHold,
                              'dropped' => context.l10n.dropped,
                              'rewatching' => context.l10n.rewatching,
                              _ => um.status.name,
                            },
                            style: textTheme.labelSmall?.copyWith(color: _statusColor(um.status.name)),
                          ),
                          if (um.episodeProgress > 0)
                            Text(context.l10n.episodeProgress(um.episodeProgress, um.totalEpisodes), style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusDot(String status) {
    return Container(width: 8, height: 8, decoration: BoxDecoration(color: _statusColor(status), shape: BoxShape.circle));
  }

  Color _statusColor(String status) {
    return switch (status) {
      'watching' => const Color(0xFF4CAF50),
      'completed' => const Color(0xFF2196F3),
      'planToWatch' => const Color(0xFF9C27B0),
      'onHold' => const Color(0xFFFF9800),
      'dropped' => const Color(0xFFF44336),
      _ => colorScheme.onSurfaceVariant,
    };
  }
}
