import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';
import '../../l10n/l10n.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/dimensions.dart';

class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerCard({
    super.key,
    this.width = 140,
    this.height = 210,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF20242E) : const Color(0xFFE5E7EB),
      highlightColor: isDark ? const Color(0xFF2A2F3A) : const Color(0xFFF3F4F6),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF20242E) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadiusDirectional.all(Radius.circular(borderRadius)),
        ),
      ),
    );
  }
}

class ShimmerMediaRow extends StatelessWidget {
  final int itemCount;
  final double cardWidth;
  final double cardHeight;

  const ShimmerMediaRow({
    super.key,
    this.itemCount = 5,
    this.cardWidth = 140,
    this.cardHeight = 210,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight + 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: Spacing.lg, end: Spacing.lg, bottom: Spacing.md),
            child: _ShimmerLine(width: 160, height: 20),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsetsDirectional.only(start: Spacing.md, end: Spacing.md),
              itemCount: itemCount,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(end: Spacing.sm),
                child: ShimmerCard(width: cardWidth, height: cardHeight),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerDetailsPage extends StatelessWidget {
  const ShimmerDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF20242E) : const Color(0xFFE5E7EB);
    final highlightColor = isDark ? const Color(0xFF2A2F3A) : const Color(0xFFF3F4F6);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 240,
              color: baseColor,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.all(Spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerLine(width: 280, height: 28),
                  const SizedBox(height: Spacing.sm),
                  _ShimmerLine(width: 200, height: 16),
                  const SizedBox(height: Spacing.lg),
                  _ShimmerLine(width: double.infinity, height: 14),
                  const SizedBox(height: 6),
                  _ShimmerLine(width: double.infinity, height: 14),
                  const SizedBox(height: 6),
                  _ShimmerLine(width: 180, height: 14),
                  const SizedBox(height: Spacing.xl),
                  _ShimmerLine(width: 120, height: 20),
                  const SizedBox(height: Spacing.md),
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsetsDirectional.only(end: Spacing.md),
                          child: Container(
                            width: 100,
                            height: 160,
                            decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
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
}

class _ShimmerLine extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerLine({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF20242E) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadiusDirectional.all(Radius.circular(4)),
      ),
    );
  }
}

class FullScreenLoader extends StatelessWidget {
  final String? message;

  const FullScreenLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          if (message != null) ...[
            const SizedBox(height: Spacing.lg),
            Text(
              message!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class ErrorWidgetView extends StatelessWidget {
  final String message;
  final String? detail;
  final VoidCallback? onRetry;

  const ErrorWidgetView({
    super.key,
    required this.message,
    this.detail,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(Spacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              message,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (detail != null) ...[
              const SizedBox(height: Spacing.sm),
              Text(
                detail!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: Spacing.xl),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
