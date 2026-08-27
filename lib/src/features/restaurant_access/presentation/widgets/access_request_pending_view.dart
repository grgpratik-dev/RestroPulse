import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class AccessRequestPendingView extends StatelessWidget {
  const AccessRequestPendingView({this.onRefresh, super.key});

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.infoSurface,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppIcons.hourglass_top_rounded,
                  colorFilter: const ColorFilter.mode(
                    AppColors.info,
                    BlendMode.srcIn,
                  ),
                  width: 36,
                  height: 36,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              Text(
                'Request sent',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                'The restaurant owner needs to approve your viewer access before you can continue.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spaceMd,
                  vertical: AppSpacing.spaceSm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warningSoft,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.schedule_rounded,
                      colorFilter: const ColorFilter.mode(
                        AppColors.warning,
                        BlendMode.srcIn,
                      ),
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: AppSpacing.spaceXs),
                    const Expanded(
                      child: Text(
                        'Waiting for owner approval',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              Text(
                'We’ll notify you when the owner approves or declines your request.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.neutral600,
                  height: 1.4,
                ),
              ),
              if (onRefresh != null) ...[
                const SizedBox(height: AppSpacing.spaceLg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onRefresh,
                    icon: SvgPicture.asset(
                      AppIcons.refresh_rounded,
                      width: 18,
                      height: 18,
                    ),
                    label: const Text('Check Again'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
