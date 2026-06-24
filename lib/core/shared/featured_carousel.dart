import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedCarousel extends StatefulWidget {
  final List<FeaturedCarouselItem> items;
  final Duration autoScrollInterval;
  final double height;

  const FeaturedCarousel({
    super.key,
    required this.items,
    this.autoScrollInterval = const Duration(seconds: 5),
    this.height = 460,
  });

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    if (widget.items.length <= 1) return;
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(widget.autoScrollInterval, (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % widget.items.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _startAutoScroll();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: widget.height,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsetsDirectional.only(
                    start: index == _currentPage ? 0 : 8,
                    end: index == _currentPage ? 0 : 8,
                    top: index == _currentPage ? 0 : 12,
                    bottom: index == _currentPage ? 0 : 12,
                  ),
                  child: _FeaturedItem(
                    item: item,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                    onTap: item.onTap,
                  ),
                );
              },
            ),
          ),
          if (widget.items.length > 1)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 16, bottom: 8),
              child: _DotIndicators(
                count: widget.items.length,
                currentIndex: _currentPage,
                colorScheme: colorScheme,
              ),
            ),
        ],
      ),
    );
  }
}

class _FeaturedItem extends StatelessWidget {
  final FeaturedCarouselItem item;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback? onTap;

  const _FeaturedItem({
    required this.item,
    required this.colorScheme,
    required this.textTheme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusDirectional.all(Radius.circular(16)),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.backdropUrl != null)
              CachedNetworkImage(
                imageUrl: item.backdropUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _ShimmerBackdrop(),
                errorWidget: (context, url, error) => _FallbackBackdrop(colorScheme: colorScheme),
              )
            else
              _FallbackBackdrop(colorScheme: colorScheme),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.9),
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              bottom: 0,
              start: 0,
              end: 0,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.voteAverage != null || item.genreTags != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (item.voteAverage != null) ...[
                            Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              item.voteAverage!.toStringAsFixed(1),
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (item.genreTags != null) const SizedBox(width: 12),
                          ],
                          if (item.genreTags != null)
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: item.genreTags!.map((tag) {
                                    return Padding(
                                      padding: const EdgeInsetsDirectional.only(end: 6),
                                      child: Container(
                                        padding: const EdgeInsetsDirectional.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadiusDirectional.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: textTheme.labelSmall?.copyWith(
                                            color: Colors.white,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.subtitle!,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBackdrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF20242E) : const Color(0xFFE5E7EB),
      highlightColor: isDark ? const Color(0xFF2A2F3A) : const Color(0xFFF3F4F6),
      child: Container(color: isDark ? const Color(0xFF20242E) : const Color(0xFFE5E7EB)),
    );
  }
}

class _FallbackBackdrop extends StatelessWidget {
  final ColorScheme colorScheme;

  const _FallbackBackdrop({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.movie_outlined, size: 48, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _DotIndicators extends StatelessWidget {
  final int count;
  final int currentIndex;
  final ColorScheme colorScheme;

  const _DotIndicators({
    required this.count,
    required this.currentIndex,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsetsDirectional.only(end: 6),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
          ),
        );
      }),
    );
  }
}

class FeaturedCarouselItem {
  final String title;
  final String? backdropUrl;
  final double? voteAverage;
  final List<String>? genreTags;
  final String? subtitle;
  final VoidCallback? onTap;

  const FeaturedCarouselItem({
    required this.title,
    this.backdropUrl,
    this.voteAverage,
    this.genreTags,
    this.subtitle,
    this.onTap,
  });
}
