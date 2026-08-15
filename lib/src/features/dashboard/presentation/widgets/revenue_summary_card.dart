import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';

class RevenueSummaryCard extends StatelessWidget {
  const RevenueSummaryCard({required this.hasData, super.key});

  final bool hasData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomContainer(
      borderRadius: AppRadius.lg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.splashAccent.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(
              Icons.payments_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Revenue",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.space2xs),
                Text(
                  hasData ? 'Rs 28,450' : '—',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (hasData)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceSm,
                vertical: AppSpacing.spaceXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.splashAccent.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '↑ 12.4%',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'vs yesterday',
                    style: TextStyle(fontSize: 11, color: AppColors.primary),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
