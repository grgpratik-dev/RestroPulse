import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

/// Shared heading for top-level operational feature screens.
class AppFeatureHeader extends StatelessWidget {
  const AppFeatureHeader({
    required this.title,
    required this.subtitle,
    this.contextLabel,
    this.contextIcon = AppIcons.calendar_today_outlined,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? contextLabel;
  final String contextIcon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.ink,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.spaceSm),
              trailing!,
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (contextLabel != null) ...[
          const SizedBox(height: AppSpacing.spaceSm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spaceSm,
              vertical: AppSpacing.spaceXs,
            ),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: AppColors.neutral300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(contextIcon, size: 16, color: AppColors.neutral700),
                const SizedBox(width: AppSpacing.spaceXs),
                Text(
                  contextLabel!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.neutral700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
