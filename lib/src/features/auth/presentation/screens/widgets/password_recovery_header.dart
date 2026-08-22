import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../../../../app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class PasswordRecoveryHeader extends StatelessWidget {
  const PasswordRecoveryHeader({
    required this.title,
    required this.message,
    this.success = false,
    super.key,
  });

  final String title;
  final String message;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = success ? AppColors.success : AppColors.primary;
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: success ? AppColors.successSurface : AppColors.mintSurface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: SvgPicture.asset(
            success
                ? AppIcons.mark_email_read_outlined
                : AppIcons.lock_reset_rounded,
            colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
            width: 36,
            height: 36,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceLg),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.neutral700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
