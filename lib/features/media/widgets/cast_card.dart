import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';

class CastCard extends StatelessWidget {
  final String name;
  final String? character;
  final String? profilePath;

  const CastCard({
    super.key,
    required this.name,
    this.character,
    this.profilePath,
  });

  @override
  Widget build(BuildContext context) {
    final profileUrl = profilePath != null
        ? '${AppConstants.tmdbImageBaseUrl}/w185$profilePath'
        : null;

    return SizedBox(
      width: 100,
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: context.colorScheme.surfaceContainerHighest,
            child: ClipOval(
              child: profileUrl != null
                  ? CachedNetworkImage(
                      imageUrl: profileUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: context.colorScheme.surfaceContainerHighest,
                        highlightColor: context.colorScheme.surface,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.person_rounded,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : Icon(
                      Icons.person_rounded,
                      size: 36,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
            ),
          ),
          SizedBox(height: 6),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (character != null) ...[
            SizedBox(height: 2),
            Text(
              character!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
