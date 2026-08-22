import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({required this.onEdit, super.key});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.splashAccent.withValues(alpha: 0.55),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RestaurantAvatar(),
          const SizedBox(width: AppSpacing.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Boys to Serve',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.space2xs),
                Text(
                  'Pratik Gurung',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.space2xs),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.location_on_outlined,
                      colorFilter: ColorFilter.mode(
                        colorScheme.onSurfaceVariant,
                        BlendMode.srcIn,
                      ),
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: AppSpacing.space2xs),
                    Flexible(
                      child: Text(
                        'Pokhara, Nepal',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                OutlinedButton.icon(
                  key: const ValueKey('profile-edit-button'),
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 38),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spaceSm,
                    ),
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.28),
                    ),
                  ),
                  icon: SvgPicture.asset(
                    AppIcons.edit_outlined,
                    width: 17,
                    height: 17,
                  ),
                  label: const Text('Edit Restaurant'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantAvatar extends StatelessWidget {
  const _RestaurantAvatar();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Restaurant logo placeholder',
      image: true,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: SvgPicture.asset(
          AppIcons.storefront_rounded,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
        ),
      ),
    );
  }
}
