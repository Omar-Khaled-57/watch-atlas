import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/dimensions.dart';
import '../../../l10n/l10n.dart';
import '../../../core/extensions/context_extensions.dart';
import '../providers/profile_providers.dart';

class ActivityTile extends StatelessWidget {
  final UserActivity activity;
  final VoidCallback? onTap;

  const ActivityTile({
    super.key,
    required this.activity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(colorScheme),
            const SizedBox(width: Spacing.md),
            if (activity.mediaPoster != null)
              ClipRRect(
                borderRadius: BorderRadiusDirectional.all(Radius.circular(6)),
                child: SizedBox(
                  width: 44,
                  height: 64,
                  child: CachedNetworkImage(
                    imageUrl: activity.mediaPoster!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.movie_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            if (activity.mediaPoster != null) const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (activity.mediaTitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      activity.mediaTitle!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (activity.createdAt != null) ...[
                    const SizedBox(height: Spacing.xs),
                    Text(
                      _formatTime(activity.createdAt!, context),
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme) {
    IconData icon;
    Color color;
    switch (activity.type) {
      case 'watch':
        icon = Icons.play_circle_fill_rounded;
        color = const Color(0xFF22C55E);
      case 'review':
        icon = Icons.rate_review_rounded;
        color = const Color(0xFFEAB308);
      case 'rating':
        icon = Icons.star_rounded;
        color = const Color(0xFFEAB308);
      case 'list':
        icon = Icons.list_alt_rounded;
        color = const Color(0xFF3B82F6);
      case 'follow':
        icon = Icons.person_add_rounded;
        color = const Color(0xFF8B5CF6);
      case 'recommendation':
        icon = Icons.recommend_rounded;
        color = const Color(0xFFEC4899);
      default:
        icon = Icons.circle_rounded;
        color = colorScheme.onSurfaceVariant;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadiusDirectional.all(Radius.circular(10)),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  String _formatTime(DateTime dateTime, BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes.toDouble());
    if (diff.inHours < 24) return l10n.hoursAgo(diff.inHours.toDouble());
    if (diff.inDays < 7) return l10n.daysAgo(diff.inDays.toDouble());
    return DateFormat.yMd(Localizations.localeOf(context).toString()).format(dateTime);
  }
}
