import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class RestaurantLogoSelector extends StatelessWidget {
  const RestaurantLogoSelector({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spaceSm),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral300),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.mintChip,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const AppIcon(
                  AppIcons.add_photo_alternate_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add restaurant logo',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2xs),
                    Text(
                      'Optional · You can add this later',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
              const AppIcon(
                AppIcons.chevron_right_rounded,
                color: AppColors.neutral600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
