import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/app/theme/app_typography.dart';
import 'package:restropulse/src/core/widgets/app_divider.dart';
import 'package:restropulse/src/core/widgets/app_card.dart';

class TodaySalesSummaryCard extends StatelessWidget {
  const TodaySalesSummaryCard({
    required this.revenue,
    required this.change,
    required this.orders,
    required this.averageOrder,
    super.key,
  });

  final int revenue;
  final double change;
  final int orders;
  final int averageOrder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.decimalPattern();
    final changeDirection = change >= 0 ? '↑' : '↓';

    return AppCard(
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
            'Rs ${currency.format(revenue)}',
            style: AppTypography.metricLarge.copyWith(color: AppColors.surface),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            '$changeDirection ${change.abs().toStringAsFixed(1)}% vs yesterday',
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
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(label: 'Orders', value: '$orders'),
                  ),
                  const AppDivider.vertical(color: AppColors.splashAccent),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Average Order',
                      value: 'Rs ${currency.format(averageOrder)}',
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
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.surface),
        ),
      ],
    );
  }
}
