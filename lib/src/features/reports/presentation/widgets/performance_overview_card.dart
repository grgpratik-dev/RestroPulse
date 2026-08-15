import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/report_data.dart';

class PerformanceOverviewCard extends StatelessWidget {
  const PerformanceOverviewCard({
    required this.report,
    this.hasExpenseData = true,
    super.key,
  });

  final ReportSnapshot report;
  final bool hasExpenseData;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return CustomContainer(
      color: const Color(0xFF047857),
      borderColor: const Color(0xFF047857),
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Compared with previous period',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Revenue',
                  value: 'Rs ${currency.format(report.revenue)}',
                  change: report.revenueChange,
                  changeIsGood: true,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceMd),
              Expanded(
                child: _OverviewMetric(
                  label: 'Expenses',
                  value: hasExpenseData
                      ? 'Rs ${currency.format(report.expenses)}'
                      : 'Unavailable',
                  change: hasExpenseData ? report.expenseChange : null,
                  changeIsGood: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Estimated Profit',
                  value: hasExpenseData
                      ? 'Rs ${currency.format(report.profit)}'
                      : 'Unavailable',
                  change: hasExpenseData ? report.profitChange : null,
                  changeIsGood: report.profitChange >= 0,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceMd),
              Expanded(
                child: _OverviewMetric(
                  label: 'Profit Margin',
                  value: hasExpenseData
                      ? '${report.profitMargin.toStringAsFixed(1)}%'
                      : 'Unavailable',
                  change: hasExpenseData ? report.marginChange : null,
                  changeIsGood: report.marginChange >= 0,
                  isPoints: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    required this.change,
    required this.changeIsGood,
    this.isPoints = false,
  });

  final String label;
  final String value;
  final double? change;
  final bool changeIsGood;
  final bool isPoints;

  @override
  Widget build(BuildContext context) {
    final isUp = (change ?? 0) >= 0;
    final color = changeIsGood
        ? const Color(0xFFB7F7DF)
        : const Color(0xFFFFD5C7);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 5),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        if (change == null)
          Text(
            'Add expense data',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.75),
            ),
          )
        else
          Text(
            '${isUp ? '↑' : '↓'} ${change!.abs().toStringAsFixed(1)}${isPoints ? ' pts' : '%'}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}
