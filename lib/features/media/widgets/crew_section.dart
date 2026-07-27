import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../l10n/l10n.dart';
import 'detail_section_header.dart';

/// Key crew members (Director, Producer, Writer) list.
class CrewSection extends StatelessWidget {
  final Map<String, dynamic> credits;

  const CrewSection({super.key, required this.credits});

  @override
  Widget build(BuildContext context) {
    final crew = credits['crew'] as List<dynamic>? ?? [];
    if (crew.isEmpty) return const SizedBox.shrink();

    final keyRoles = crew
        .where(
          (c) => [
            'Director',
            'Producer',
            'Writer',
            'Screenplay',
          ].contains(c['job'] as String?),
        )
        .take(6)
        .toList();
    if (keyRoles.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailSectionHeader(title: context.l10n.crew),
          SizedBox(height: Spacing.md),
          ...keyRoles.map((person) {
            return Padding(
              padding: EdgeInsetsDirectional.only(bottom: Spacing.sm),
              child: Semantics(
                label: '${person['name'] ?? ''}, ${person['job'] ?? ''}',
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          context.colorScheme.surfaceContainerHighest,
                      backgroundImage: person['profile_path'] != null
                          ? CachedNetworkImageProvider(
                              '${AppConstants.tmdbImageBaseUrl}/w185${person['profile_path']}',
                            )
                          : null,
                      child: person['profile_path'] == null
                          ? Icon(
                              Icons.person_rounded,
                              color: context.colorScheme.onSurfaceVariant,
                            )
                          : null,
                    ),
                    SizedBox(width: Spacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person['name'] as String? ?? '',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          person['job'] as String? ?? '',
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
          }),
        ],
      ),
    );
  }
}
