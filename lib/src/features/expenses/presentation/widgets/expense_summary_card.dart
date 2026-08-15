import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/expense.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({required this.snapshot, super.key});

  final ExpensePeriodSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return CustomContainer(
      color: const Color(0xFF102037),
      borderColor: const Color(0xFF102037),
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL EXPENSES',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
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
                color: Colors.white,
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
                  color: Color(0xFFFFC7A5),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                snapshot.comparisonLabel,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.spaceSm),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: 'Transactions',
                    value: '${snapshot.transactions}',
                  ),
                ),
                Container(
                  width: 1,
                  height: 38,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                Expanded(
                  flex: 2,
                  child: _SummaryMetric(
                    label: 'Largest category',
                    value: 'Ingredients · Rs 210,000',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.trending_up_rounded,
                size: 19,
                color: Color(0xFFFFC7A5),
              ),
              const SizedBox(width: AppSpacing.spaceXs),
              Expanded(
                child: Text(
                  'Expenses are rising. Spending increased ${snapshot.change.toStringAsFixed(1)}% compared with the previous period.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ),
            ],
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
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
