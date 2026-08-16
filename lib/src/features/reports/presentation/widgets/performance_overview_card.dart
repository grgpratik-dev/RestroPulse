import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
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
      color: AppColors.primaryStrong,
      borderColor: AppColors.primaryStrong,
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
            report.period.comparisonLabel,
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
                  positiveIsGood: true,
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
                  positiveIsGood: false,
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
                  positiveIsGood: true,
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
                  positiveIsGood: true,
                  isPoints: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Divider(color: Colors.white.withValues(alpha: .18), height: 1),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(
                child: _ContextMetric(
                  label: 'Orders',
                  value: NumberFormat.decimalPattern().format(report.orders),
                ),
              ),
              Expanded(
                child: _ContextMetric(
                  label: 'Avg. Order',
                  value:
                      'Rs ${currency.format(report.averageOrderValue.round())}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(
                child: _ContextMetric(
                  label: 'Food Cost',
                  value: '${report.foodCost.toStringAsFixed(1)}%',
                ),
              ),
              Expanded(
                child: _ContextMetric(
                  label: 'Wastage',
                  value: 'Rs ${currency.format(report.wastage)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContextMetric extends StatelessWidget {
  const _ContextMetric({required this.label, required this.value});

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
            color: Colors.white.withValues(alpha: .7),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
    required this.label,
    required this.value,
    required this.change,
    required this.positiveIsGood,
    this.isPoints = false,
  });

  final String label;
  final String value;
  final double? change;
  final bool positiveIsGood;
  final bool isPoints;

  @override
  Widget build(BuildContext context) {
    final isUp = (change ?? 0) >= 0;
    final isGood = isUp == positiveIsGood;
    final color = isGood ? AppColors.splashAccent : AppColors.expenseSoft;
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
