import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/dimensions.dart';
import '../../core/extensions/context_extensions.dart';
import 'providers/analytics_providers.dart';
import 'widgets/bar_chart_widget.dart';
import 'widgets/stats_card.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isDark = context.isDark;

    final statsAsync = ref.watch(watchStatisticsProvider);
    final genreDistAsync = ref.watch(genreDistributionProvider);
    final countryDistAsync = ref.watch(countryDistributionProvider);
    final weeklyAsync = ref.watch(weeklyActivityProvider);
    final monthlyAsync = ref.watch(monthlyActivityProvider);
    final yearlyAsync = ref.watch(yearlyActivityProvider);
    final favoriteGenreAsync = ref.watch(favoriteGenreProvider);
    final favoriteCountryAsync = ref.watch(favoriteCountryProvider);
    final decadeAsync = ref.watch(mostWatchedDecadeProvider);
    final ratingDistAsync = ref.watch(ratingDistributionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(watchStatisticsProvider.future),
            ref.refresh(genreDistributionProvider.future),
            ref.refresh(countryDistributionProvider.future),
            ref.refresh(weeklyActivityProvider.future),
            ref.refresh(monthlyActivityProvider.future),
            ref.refresh(yearlyActivityProvider.future),
            ref.refresh(favoriteGenreProvider.future),
            ref.refresh(favoriteCountryProvider.future),
            ref.refresh(mostWatchedDecadeProvider.future),
            ref.refresh(ratingDistributionProvider.future),
          ]);
        },
        child: ListView(
          controller: _scrollController,
          padding: EdgeInsetsDirectional.only(
            top: MediaQuery.of(context).padding.top,
            start: Spacing.lg,
            end: Spacing.lg,
            bottom: Spacing.xxl,
          ),
          children: [
            SizedBox(height: Spacing.sm),
            statsAsync.when(
              loading: () => const _StatsGridShimmer(),
              error: (e, _) => Center(child: Text('Failed to load stats: $e')),
              data: (stats) => _buildStatsGrid(stats, colorScheme, textTheme),
            ),
            SizedBox(height: Spacing.xl),
            favoriteGenreAsync.whenData((fg) => fg).maybeWhen(
              data: (fg) {
                if (fg == null) return const SizedBox.shrink();
                return _buildFavoriteCard(
                  'Favorite Genre',
                  fg.label,
                  Icons.category_rounded,
                  colorScheme,
                  textTheme,
                ).animate().fadeIn(duration: 300.ms);
              },
              orElse: () => const SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            _buildSectionHeader('Weekly Activity', Icons.show_chart_rounded),
            SizedBox(height: Spacing.md),
            weeklyAsync.when(
              loading: () => const _ChartShimmer(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (data) {
                final points = data.map((d) {
                  final parts = d.date.split('-');
                  final label = '${int.parse(parts[1])}/${int.parse(parts[2])}';
                  return BarChartDataPoint(label: label, value: d.count.toDouble());
                }).toList();
                return BarChartWidget(data: points, barColor: colorScheme.primary);
              },
            ),
            SizedBox(height: Spacing.xl),
            _buildSectionHeader('Monthly Activity', Icons.bar_chart_rounded),
            SizedBox(height: Spacing.md),
            monthlyAsync.when(
              loading: () => const _ChartShimmer(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (data) {
                final points = data.map((d) {
                  final parts = d.month.split('-');
                  final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                  return BarChartDataPoint(
                    label: months[int.parse(parts[1])],
                    value: d.count.toDouble(),
                  );
                }).toList();
                return BarChartWidget(data: points, barColor: colorScheme.secondary);
              },
            ),
            SizedBox(height: Spacing.xl),
            _buildSectionHeader('Genre Distribution', Icons.pie_chart_rounded),
            SizedBox(height: Spacing.md),
            genreDistAsync.when(
              loading: () => const _ChartShimmer(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (data) {
                if (data.isEmpty) return const EmptyAnalytics();
                return _buildPieChart(data, colorScheme);
              },
            ),
            SizedBox(height: Spacing.xl),
            _buildSectionHeader('Country Distribution', Icons.public_rounded),
            SizedBox(height: Spacing.md),
            countryDistAsync.when(
              loading: () => const _ChartShimmer(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (data) {
                if (data.isEmpty) return const EmptyAnalytics();
                return _buildPieChart(data, colorScheme);
              },
            ),
            SizedBox(height: Spacing.xl),
            _buildSectionHeader('Yearly Activity', Icons.trending_up_rounded),
            SizedBox(height: Spacing.md),
            yearlyAsync.when(
              loading: () => const _ChartShimmer(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (data) {
                if (data.isEmpty) return const EmptyAnalytics();
                return _buildLineChart(data, colorScheme, isDark);
              },
            ),
            SizedBox(height: Spacing.xl),
            favoriteCountryAsync.whenData((fc) => fc).maybeWhen(
              data: (fc) {
                if (fc == null) return const SizedBox.shrink();
                return _buildFavoriteCard(
                  'Favorite Country',
                  fc.label,
                  Icons.flag_rounded,
                  colorScheme,
                  textTheme,
                ).animate().fadeIn(duration: 300.ms);
              },
              orElse: () => const SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
            _buildSectionHeader('Rating Distribution', Icons.star_rounded),
            SizedBox(height: Spacing.md),
            ratingDistAsync.when(
              loading: () => const _ChartShimmer(),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (data) => _buildRatingDistribution(data, colorScheme, textTheme),
            ),
            SizedBox(height: Spacing.xl),
            decadeAsync.whenData((d) => d).maybeWhen(
              data: (decade) {
                if (decade == null) return const SizedBox.shrink();
                return _buildMostWatchedDecade(decade, colorScheme, textTheme)
                    .animate().fadeIn(duration: 300.ms);
              },
              orElse: () => const SizedBox.shrink(),
            ),
            SizedBox(height: Spacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(WatchStatistics stats, ColorScheme cs, TextTheme tt) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: Spacing.md,
              crossAxisSpacing: Spacing.md,
          childAspectRatio: 1.3,
          children: [
            StatsCard(
              title: 'Total Watched',
              value: stats.totalWatched.toString(),
              icon: Icons.check_circle_rounded,
              iconColor: cs.primary,
            ),
            StatsCard(
              title: 'Total Episodes',
              value: stats.totalEpisodes.toString(),
              icon: Icons.videocam_rounded,
              iconColor: cs.tertiary,
            ),
            StatsCard(
              title: 'Total Hours',
              value: '${stats.totalHours}h',
              icon: Icons.schedule_rounded,
              iconColor: Colors.amber,
            ),
            StatsCard(
              title: 'Avg Rating',
              value: stats.averageRating > 0
                  ? stats.averageRating.toStringAsFixed(1)
                  : '--',
              icon: Icons.star_rounded,
              iconColor: Colors.orange,
            ),
          ],
        ).animate().fadeIn(duration: 400.ms);
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: cs.primary),
        SizedBox(width: Spacing.sm),
        Text(title, style: tt.titleMedium),
      ],
    );
  }

  Widget _buildPieChart(List<DistributionItem> data, ColorScheme cs) {
    final chartColors = [
      cs.primary, cs.secondary, cs.tertiary,
      Colors.amber, Colors.green, Colors.blue,
      Colors.purple, Colors.teal, Colors.pink,
      Colors.indigo, Colors.cyan, Colors.orange,
    ];

    final total = data.fold<int>(0, (sum, d) => sum + d.count);
    final displayed = data.length > 12 ? data.sublist(0, 11) : data;
    if (data.length > 12) {
      final otherCount = data.sublist(11).fold<int>(0, (s, d) => s + d.count);
      displayed.add(DistributionItem(label: 'Other', count: otherCount, percentage: otherCount / total));
    }

    return SizedBox(
      height: 280,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: displayed.asMap().entries.map((entry) {
                  return PieChartSectionData(
                    color: chartColors[entry.key % chartColors.length],
                    value: entry.value.count.toDouble(),
                    title: total > 0
                        ? '${(entry.value.percentage * 100).toStringAsFixed(0)}%'
                        : '0%',
                    radius: 60,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(width: Spacing.lg),
          Expanded(
            flex: 2,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayed.length,
              separatorBuilder: (_, __) => SizedBox(height: Spacing.xs),
              itemBuilder: (context, index) {
                final item = displayed[index];
                return Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: chartColors[index % chartColors.length],
                        borderRadius: BorderRadiusDirectional.all(Radius.circular(2)),
                      ),
                    ),
                    SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${item.count}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<ActivityYear> data, ColorScheme cs, bool isDark) {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.count.toDouble());
    }).toList();

    final maxY = data.isEmpty ? 1.0 : data.map((d) => d.count.toDouble()).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (data.length - 1).toDouble().clamp(0, double.infinity),
          minY: 0,
          maxY: (maxY * 1.3).ceilToDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? Colors.white10 : Colors.black12,
              strokeWidth: 0.5,
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: data.length > 8 ? 2 : 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(top: Spacing.sm),
                    child: Text(
                      '${data[index].year}',
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 10),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  final year = index >= 0 && index < data.length ? data[index].year : 0;
                  return LineTooltipItem(
                    '$year\n${spot.y.toInt()}',
                    TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: cs.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: cs.primary,
                    strokeWidth: 2,
                    strokeColor: cs.surface,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: cs.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
    String title,
    String value,
    IconData icon,
    ColorScheme cs,
    TextTheme tt,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(Spacing.lg),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
              ),
              child: Icon(icon, color: cs.primary, size: 24),
            ),
            SizedBox(width: Spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  SizedBox(height: Spacing.xs),
                  Text(
                    value,
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingDistribution(
    List<RatingBucket> data,
    ColorScheme cs,
    TextTheme tt,
  ) {
    final maxCount = data.isEmpty ? 1 : data.map((d) => d.count).reduce((a, b) => a > b ? a : b);
    return Column(
      children: data.map((bucket) {
        final fraction = maxCount > 0 ? bucket.count / maxCount : 0.0;
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: Spacing.sm),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Text(
                  bucket.label,
                  style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: Spacing.sm),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 20,
                    backgroundColor: cs.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      bucket.label == '9-10'
                          ? Colors.green
                          : bucket.label == '7-8'
                              ? cs.primary
                              : bucket.label == '5-6'
                                  ? Colors.amber
                                  : Colors.redAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(width: Spacing.md),
              SizedBox(
                width: 40,
                child: Text(
                  '${bucket.count}',
                  textAlign: TextAlign.end,
                  style: tt.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMostWatchedDecade(String decade, ColorScheme cs, TextTheme tt) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(Spacing.lg),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
              ),
              child: Icon(Icons.date_range_rounded, color: Colors.amber, size: 24),
            ),
            SizedBox(width: Spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Most Watched Decade',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  SizedBox(height: 4),
                  Text(
                    decade,
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyAnalytics extends StatelessWidget {
  const EmptyAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: Spacing.xl),
        child: Column(
          children: [
            Icon(Icons.info_outline_rounded, color: cs.onSurfaceVariant, size: 32),
            SizedBox(height: Spacing.sm),
            Text(
              'No data available yet',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGridShimmer extends StatelessWidget {
  const _StatsGridShimmer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: Spacing.md,
              crossAxisSpacing: Spacing.md,
          childAspectRatio: 1.3,
          children: List.generate(4, (_) => Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
            ),
          )),
        );
      },
    );
  }
}

class _ChartShimmer extends StatelessWidget {
  const _ChartShimmer();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadiusDirectional.all(Radius.circular(12)),
      ),
    );
  }
}
