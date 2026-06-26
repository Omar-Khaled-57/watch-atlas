import 'package:flutter/material.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../models/review_model.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final String? authorName;
  final String? authorAvatar;

  const ReviewCard({
    super.key,
    required this.review,
    this.authorName,
    this.authorAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsetsDirectional.only(bottom: 12),
      child: Padding(
        padding: EdgeInsetsDirectional.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: context.colorScheme.surfaceContainerHighest,
                  child: authorAvatar != null
                      ? ClipOval(
                          child: Image.network(
                            authorAvatar!,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.person_rounded,
                              size: 20,
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person_rounded,
                          size: 20,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                ),
                SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName ?? 'Anonymous',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (review.createdAt != null)
                        Text(
                          _formatDate(review.createdAt!),
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                if (review.rating != null)
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondaryContainer,
                      borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 2),
                        Text(
                          review.rating!.toStringAsFixed(1),
                          style: context.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (review.containsSpoilers)
              Container(
                margin: EdgeInsetsDirectional.only(top: 12),
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadiusDirectional.all(
                    Radius.circular(4),
                  ),
                ),
                child: Text(
                  'Contains spoilers',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            SizedBox(height: Spacing.sm),
            Text(
              review.content,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
            SizedBox(height: Spacing.sm),
            Row(
              children: [
                Icon(
                  Icons.favorite_border_rounded,
                  size: 16,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: Spacing.xs),
                Text(
                  '${review.likesCount}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: Spacing.lg),
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: Spacing.xs),
                Text(
                  '${review.commentsCount}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
