import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';

class RestaurantAccessOptionCard extends StatelessWidget {
  const RestaurantAccessOptionCard({
    required this.icon,
    required this.title,
    required this.roleLabel,
    required this.description,
    required this.permissionSummary,
    required this.actionLabel,
    required this.onTap,
    this.isViewer = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String roleLabel;
  final String description;
  final String permissionSummary;
  final String actionLabel;
  final VoidCallback onTap;
  final bool isViewer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = isViewer ? AppColors.info : AppColors.primary;
    final surface = isViewer ? AppColors.infoSurface : AppColors.mintSurface;
    final border = isViewer
        ? AppColors.info.withValues(alpha: 0.28)
        : AppColors.mintBright;

    return Semantics(
      button: true,
      label: '$title. $roleLabel. $permissionSummary',
      child: Material(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(icon, color: accent, size: 26),
                    ),
                    const SizedBox(width: AppSpacing.spaceSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.space2xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.spaceXs,
                              vertical: AppSpacing.space2xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                            child: Text(
                              roleLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral700,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isViewer
                          ? Icons.visibility_outlined
                          : Icons.verified_user_outlined,
                      color: accent,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.spaceXs),
                    Expanded(
                      child: Text(
                        permissionSummary,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                Row(
                  children: [
                    Text(
                      actionLabel,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space2xs),
                    Icon(Icons.arrow_forward_rounded, color: accent, size: 19),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
