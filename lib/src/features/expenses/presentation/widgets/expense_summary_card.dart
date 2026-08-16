import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/expense.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({
    required this.snapshot,
    required this.largestCategory,
    super.key,
  });

  final ExpensePeriodSnapshot snapshot;
  final ExpenseCategorySummary largestCategory;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return CustomContainer(
      color: AppColors.expenseForeground,
      borderColor: AppColors.expenseForeground,
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "THIS MONTH'S EXPENSES",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.surface.withValues(alpha: 0.72),
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Rs ${currency.format(snapshot.total)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: [
              Text(
                '↑ ${snapshot.change.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: AppColors.expenseBorder,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                snapshot.comparisonLabel,
                style: TextStyle(
                  color: AppColors.surface.withValues(alpha: 0.68),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.spaceSm),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.surface.withValues(alpha: 0.12),
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: 'Transactions',
                    value: '${snapshot.transactions}',
                  ),
                ),
                Container(
                  width: 1,
                  height: 52,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceMd,
                  ),
                  color: AppColors.surface.withValues(alpha: 0.18),
                ),
                Expanded(
                  child: _LargestCategoryMetric(
                    name: largestCategory.name,
                    amount: 'Rs ${currency.format(largestCategory.amount)}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LargestCategoryMetric extends StatelessWidget {
  const _LargestCategoryMetric({required this.name, required this.amount});

  final String name;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Largest category',
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.surface.withValues(alpha: 0.68),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            name,
            softWrap: true,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.surface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            softWrap: true,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: AppColors.surface.withValues(alpha: 0.82),
              fontWeight: FontWeight.w600,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.surface.withValues(alpha: 0.68),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.surface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
