import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../../../core/widgets/custom_container.dart';

class SelectedDateSummaryCard extends StatelessWidget {
  const SelectedDateSummaryCard({
    required this.dateLabel,
    required this.revenue,
    required this.orders,
    required this.averageOrder,
    required this.change,
    super.key,
  });

  final String dateLabel;
  final int revenue;
  final int orders;
  final int averageOrder;
  final double change;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final theme = Theme.of(context);
    return CustomContainer(
      color: AppColors.splashAccent.withValues(alpha: .28),
      borderColor: AppColors.primary.withValues(alpha: .12),
      borderRadius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.spaceXs),
              Text(
                dateLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            'Rs ${currency.format(revenue)}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            '${change >= 0 ? '↑' : '↓'} '
            '${change.abs().toStringAsFixed(1)}% vs previous day',
            style: theme.textTheme.bodySmall?.copyWith(
              color: change >= 0 ? AppColors.success : theme.colorScheme.error,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          _MetricsSurface(orders: orders, averageOrder: averageOrder),
        ],
      ),
    );
  }
}

class _MetricsSurface extends StatelessWidget {
  const _MetricsSurface({required this.orders, required this.averageOrder});

  final int orders;
  final int averageOrder;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceSm),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: .86),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: _HistoryMetric(label: 'Orders', value: '$orders'),
          ),
          const SizedBox(height: 34, child: AppDivider.vertical()),
          Expanded(
            child: _HistoryMetric(
              label: 'Average Order',
              value: 'Rs ${currency.format(averageOrder)}',
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryMetric extends StatelessWidget {
  const _HistoryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
