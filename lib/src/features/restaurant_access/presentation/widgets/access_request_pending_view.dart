import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';

class AccessRequestPendingView extends StatelessWidget {
  const AccessRequestPendingView({super.key});

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
                decoration: const BoxDecoration(
                  color: AppColors.infoSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  color: AppColors.info,
                  size: 36,
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
                'The owner of Boys to Serve needs to approve your viewer access.',
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
                child: const Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: AppColors.warning,
                      size: 18,
                    ),
                    SizedBox(width: AppSpacing.spaceXs),
                    Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}
