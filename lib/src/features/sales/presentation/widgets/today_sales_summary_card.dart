import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_divider.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';

class TodaySalesSummaryCard extends StatelessWidget {
  const TodaySalesSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomContainer(
      color: AppColors.primaryStrong,
      borderColor: AppColors.primaryStrong,
      borderRadius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Today's Sales",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.surface.withValues(alpha: .72),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            'Rs 28,450',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.surface,
              fontSize: 31,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            '↑ 12.4% vs yesterday',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.splashAccent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Container(
            padding: const EdgeInsets.all(AppSpacing.spaceSm),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: .1),
              border: Border.all(
                color: AppColors.surface.withValues(alpha: .12),
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(label: 'Orders', value: '42'),
                  ),
                  AppDivider.vertical(color: AppColors.splashAccent),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Average Order',
                      value: 'Rs 677',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.surface.withValues(alpha: .68),
          ),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
