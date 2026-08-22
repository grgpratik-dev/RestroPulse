import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Shared primary create action for bottom-navigation feature screens.
class AppAddFloatingActionButton extends StatelessWidget {
  const AppAddFloatingActionButton({
    required this.onPressed,
    required this.tooltip,
    required this.heroTag,
    super.key,
  });

  final VoidCallback onPressed;
  final String tooltip;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space6xl),
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        heroTag: heroTag,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: SvgPicture.asset(
          AppIcons.add_rounded,
          width: 30,
          height: 30,
          colorFilter: const ColorFilter.mode(
            AppColors.kNeutral100,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
