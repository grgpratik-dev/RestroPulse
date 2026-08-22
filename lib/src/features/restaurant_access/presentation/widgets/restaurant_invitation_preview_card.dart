import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_divider.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class RestaurantInvitationPreviewCard extends StatelessWidget {
  const RestaurantInvitationPreviewCard({required this.onRequest, super.key});

  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: const ValueKey('invitation-preview-card'),
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.mintChip,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: SvgPicture.asset(
                  AppIcons.storefront_rounded,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                  width: 27,
                  height: 27,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Boys to Serve',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space2xs),
                    Text(
                      'Pokhara, Nepal',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                AppIcons.verified_rounded,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
                width: 22,
                height: 22,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          const AppDivider(height: 1),
          const SizedBox(height: AppSpacing.spaceMd),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceSm,
                vertical: AppSpacing.spaceXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.infoSurface,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Text(
                'Viewer access',
                style: TextStyle(
                  color: AppColors.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            'Invited by owner',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.neutral600,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppIcons.visibility_outlined,
                colorFilter: const ColorFilter.mode(
                  AppColors.info,
                  BlendMode.srcIn,
                ),
                width: 19,
                height: 19,
              ),
              const SizedBox(width: AppSpacing.spaceXs),
              Expanded(
                child: Text(
                  'You can view restaurant performance, but cannot add, edit, or delete data.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          SizedBox(
            height: 52,
            child: FilledButton(
              key: const ValueKey('confirm-join-button'),
              onPressed: onRequest,
              child: const Text('Request viewer access'),
            ),
          ),
        ],
      ),
    );
  }
}
