import 'package:flutter/material.dart';

import '../themes/app_durations.dart';
import '../themes/app_radii.dart';

/// Shimmer-style skeleton placeholder.
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = AppRadii.md,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.skeleton,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + (_controller.value * 2), 0),
              end: Alignment(1 + (_controller.value * 2), 0),
              colors: [
                base.withValues(alpha: 0.55),
                base.withValues(alpha: 0.95),
                base.withValues(alpha: 0.55),
              ],
            ),
          ),
        );
      },
    );
  }
}
