import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

class AmbientGlow extends StatelessWidget {
  const AmbientGlow({super.key, required this.size, this.opacity = 0.75});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.splashAccent.withValues(alpha: opacity),
                AppColors.splashAccent.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
