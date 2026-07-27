import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';

/// Simple section header used inside the media detail screen.
class DetailSectionHeader extends StatelessWidget {
  final String title;

  const DetailSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
