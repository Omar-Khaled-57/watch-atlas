import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double radius;
  final bool showOnlineIndicator;
  final bool isLoading;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 20,
    this.showOnlineIndicator = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return _LoadingAvatar(radius: radius);
    }

    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: imageUrl != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: radius * 2,
                      height: radius * 2,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _LoadingAvatar(radius: radius),
                      errorWidget: (context, url, error) => _InitialsAvatar(
                        initials: initials,
                        radius: radius,
                        colorScheme: colorScheme,
                      ),
                    ),
                  )
                : _InitialsAvatar(
                    initials: initials,
                    radius: radius,
                    colorScheme: colorScheme,
                  ),
          ),
          if (showOnlineIndicator)
            PositionedDirectional(
              bottom: 0,
              end: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String? initials;
  final double radius;
  final ColorScheme colorScheme;

  const _InitialsAvatar({
    required this.initials,
    required this.radius,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = initials != null && initials!.isNotEmpty
        ? initials!.length >= 2
            ? initials!.substring(0, 2).toUpperCase()
            : initials!.toUpperCase()
        : '?';

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
      child: Text(
        displayText,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}

class _LoadingAvatar extends StatelessWidget {
  final double radius;

  const _LoadingAvatar({required this.radius});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CircleAvatar(
      radius: radius,
      backgroundColor: isDark ? const Color(0xFF20242E) : const Color(0xFFE5E7EB),
    );
  }
}
