import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';

/// A neutral loading placeholder surface shared by feature skeletons.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    required this.height,
    this.width = double.infinity,
    this.borderRadius = AppRadius.lg,
    super.key,
  });

  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
