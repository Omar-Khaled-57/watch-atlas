import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StaggeredItem extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration delay;
  final Duration duration;

  const StaggeredItem({
    super.key,
    required this.index,
    required this.child,
    this.delay = const Duration(milliseconds: 40),
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(duration: duration, delay: delay * index, curve: Curves.easeOutCubic)
        .slideY(
          begin: 0.04,
          end: 0,
          duration: duration,
          delay: delay * index,
          curve: Curves.easeOutCubic,
        );
  }
}
