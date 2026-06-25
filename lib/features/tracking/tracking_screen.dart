import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userMediaProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 16,
                  end: 16,
                  top: MediaQuery.of(context).padding.top + 16,
                  bottom: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Tracking',
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StatsRow(stats: stats, colorScheme: colorScheme, textTheme: textTheme),
                  ],
                ),
              ),
            ),
            if (recentlyUpdated.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 4),
                  child: Text(
                    'Recently Updated',
                    style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            if (recentlyUpdated.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 8),
                    itemCount: recentlyUpdated.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = recentlyUpdated[index];
                      return SizedBox(
                        width: 120,
                        child: ProgressCard(
                          userMedia: item,
                          title: 'Media #${item.mediaId}',
                          posterUrl: null,
                          onTap: () => _navigateToDetail(item.mediaId),
                          onLongPress: () => _showQuickStatus(context, item),
                        ),
                      );
                    },
                  ),
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
                tabs: const [
                  Tab(text: 'Watching'),
                  Tab(text: 'Completed'),
                  Tab(text: 'On Hold'),
                  Tab(text: 'Dropped'),
                  Tab(text: 'Plan To Watch'),
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

  void _navigateToDetail(int mediaId) {
    context.push('/media/$mediaId');
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
    return Row(
      children: [
        _StatItem(
          value: stats['totalWatched'] ?? 0,
          label: 'Completed',
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        _StatDivider(colorScheme: colorScheme),
        _StatItem(
          value: stats['totalEpisodes'] ?? 0,
          label: 'Episodes',
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
        _StatDivider(colorScheme: colorScheme),
        _StatItem(
          value: stats['totalHours'] ?? 0,
          label: 'Hours',
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(32),
          child: Text('Failed to load tracking data', style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
        ),
      ),
      data: (allMedia) {
        final filtered = allMedia.where((m) => m.status == status).toList();
        if (filtered.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded, size: 64, color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    'No media in this list',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsetsDirectional.all(12),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              return ProgressCard(
                userMedia: item,
                title: 'Media #${item.mediaId}',
                onTap: () => context.push('/media/${item.mediaId}'),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => QuickStatusDialog(userMedia: item),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
