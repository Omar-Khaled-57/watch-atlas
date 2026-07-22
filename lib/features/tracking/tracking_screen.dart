import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../l10n/l10n.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/dimensions.dart';
import '../../core/shared/horizontal_carousel.dart';
import '../../core/shared/staggered_item.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/models/media_enums.dart';
import '../../models/user_media_model.dart';
import 'providers/tracking_providers.dart';
import 'widgets/progress_card.dart';
import 'widgets/quick_status_dialog.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final stats = ref.watch(trackingStatsProvider);
    final recentlyUpdated = ref.watch(recentlyUpdatedProvider);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final crossAxisCount = isDesktop ? 5 : isTablet ? 4 : 3;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.tracking)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userMediaProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(Spacing.lg, Spacing.lg, Spacing.lg, Spacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatsRow(stats: stats, colorScheme: colorScheme, textTheme: textTheme),
                  ],
                ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.03, curve: Curves.easeOutCubic),
              ),
            ),
            if (recentlyUpdated.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(Spacing.lg, Spacing.sm, Spacing.lg, Spacing.xs),
                  child: Text(
                    context.l10n.recentlyUpdated,
                    style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            if (recentlyUpdated.isNotEmpty)
              SliverToBoxAdapter(
                child: HorizontalCarousel(
                  height: 180,
                  itemCount: recentlyUpdated.length,
                  separatorWidth: Spacing.sm,
                  padding: const EdgeInsetsDirectional.fromSTEB(Spacing.md, 0, Spacing.md, Spacing.sm),
                  itemBuilder: (context, index) {
                    final item = recentlyUpdated[index];
                    return SizedBox(
                      width: 120,
                      child: _MediaTile(
                        userMedia: item,
                        onTap: () => _navigateToDetail(item.mediaId, item.mediaType),
                        onLongPress: () => _showQuickStatus(context, item),
                      ),
                    );
                  },
                ),
              ),
            SliverToBoxAdapter(
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: colorScheme.onSurface,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                indicatorColor: colorScheme.primary,
                labelStyle: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                unselectedLabelStyle: textTheme.bodySmall,
                tabs: [
                  _BadgeTab(label: context.l10n.watching, status: WatchStatus.watching),
                  _BadgeTab(label: context.l10n.completed, status: WatchStatus.completed),
                  _BadgeTab(label: context.l10n.onHold, status: WatchStatus.onHold),
                  _BadgeTab(label: context.l10n.dropped, status: WatchStatus.dropped),
                  _BadgeTab(label: context.l10n.planToWatch, status: WatchStatus.planToWatch),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _MediaGrid(status: WatchStatus.watching, crossAxisCount: crossAxisCount),
                  _MediaGrid(status: WatchStatus.completed, crossAxisCount: crossAxisCount),
                  _MediaGrid(status: WatchStatus.onHold, crossAxisCount: crossAxisCount),
                  _MediaGrid(status: WatchStatus.dropped, crossAxisCount: crossAxisCount),
                  _MediaGrid(status: WatchStatus.planToWatch, crossAxisCount: crossAxisCount),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickStatus(BuildContext context, UserMediaModel item) {
    showDialog(
      context: context,
      builder: (context) => QuickStatusDialog(userMedia: item),
    );
  }

  void _navigateToDetail(int mediaId, MediaType mediaType) {
    context.push('/media/${mediaType.name}/$mediaId');
  }
}

class _StatsRow extends StatelessWidget {
  final Map<String, int> stats;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatsRow({
    required this.stats,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        _StatItem(
          value: stats['totalWatched'] ?? 0,
          label: l10n.completed,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        _StatDivider(colorScheme: colorScheme),
        _StatItem(
          value: stats['totalEpisodes'] ?? 0,
          label: l10n.totalEpisodes,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        _StatDivider(colorScheme: colorScheme),
        _StatItem(
          value: stats['totalHours'] ?? 0,
          label: l10n.totalHours,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StatItem({
    required this.value,
    required this.label,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  final ColorScheme colorScheme;
  const _StatDivider({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: colorScheme.outline.withValues(alpha: 0.3),
    );
  }
}

class _MediaGrid extends ConsumerWidget {
  final WatchStatus status;
  final int crossAxisCount;

  const _MediaGrid({required this.status, required this.crossAxisCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(userMediaProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return mediaAsync.when(
      loading: () => _ShimmerGrid(crossAxisCount: crossAxisCount),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(Spacing.xxl),
          child: Text(context.l10n.failedToLoadTracking, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
        ),
      ),
      data: (allMedia) {
        final filtered = allMedia.where((m) => m.status == status).toList();
        if (filtered.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(Spacing.section),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded, size: 64, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: Spacing.lg),
                  Text(
                    context.l10n.noMediaInList,
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsetsDirectional.all(Spacing.md),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.6,
            crossAxisSpacing: Spacing.sm,
            mainAxisSpacing: Spacing.sm,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              return StaggeredItem(
                index: index,
                child: _MediaTile(
                  userMedia: item,
                  onTap: () => context.push('/media/${item.mediaType.name}/${item.mediaId}'),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => QuickStatusDialog(userMedia: item),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _MediaTile extends ConsumerWidget {
  final UserMediaModel userMedia;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _MediaTile({
    required this.userMedia,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(mediaByIdProvider((mediaId: userMedia.mediaId, mediaType: userMedia.mediaType)));

    return mediaAsync.when(
      loading: () => ProgressCard(
        userMedia: userMedia,
        title: '',
        onTap: onTap,
        onLongPress: onLongPress,
      ),
      error: (_, __) => ProgressCard(
        userMedia: userMedia,
        title: context.l10n.mediaWithId(userMedia.mediaId.toString()),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
      data: (media) {
        final posterUrl = media?.posterPath != null
            ? AppConstants.mediaImageUrl(media!.posterPath!, size: 'w342')
            : null;
        return ProgressCard(
          userMedia: userMedia,
          title: media?.title ?? context.l10n.mediaWithId(userMedia.mediaId.toString()),
          posterUrl: posterUrl,
          onTap: onTap,
          onLongPress: onLongPress,
        );
      },
    );
  }
}

class _BadgeTab extends ConsumerWidget {
  final String label;
  final WatchStatus status;

  const _BadgeTab({required this.label, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(userMediaByStatusProvider(status)).length;
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ShimmerGrid extends StatelessWidget {
  final int crossAxisCount;
  const _ShimmerGrid({required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF20242E) : const Color(0xFFE5E7EB);
    final highlight = isDark ? const Color(0xFF2A2F3A) : const Color(0xFFF3F4F6);
    return Padding(
      padding: const EdgeInsetsDirectional.all(Spacing.md),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.6,
          crossAxisSpacing: Spacing.sm,
          mainAxisSpacing: Spacing.sm,
        ),
        itemCount: crossAxisCount * 3,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadiusDirectional.all(Radius.circular(Spacing.cardRadiusSm)),
            ),
          ),
        ),
      ),
    );
  }
}
