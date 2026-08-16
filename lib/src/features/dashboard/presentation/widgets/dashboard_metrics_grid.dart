import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import 'dashboard_metric_card.dart';

class DashboardMetricsGrid extends StatelessWidget {
  const DashboardMetricsGrid({
    required this.isEmpty,
    required this.isPartial,
    super.key,
  });

  final bool isEmpty;
  final bool isPartial;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DashboardMetricCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Orders',
                  value: isEmpty ? '—' : '142',
                  comparison: isEmpty ? null : '↑ 7.2%',
                  status: MetricStatus.positive,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: DashboardMetricCard(
                  icon: Icons.payments_outlined,
                  title: 'Avg. Order',
                  value: isEmpty ? '—' : 'Rs 201',
                  comparison: isEmpty ? null : '↑ 4.8%',
                  status: MetricStatus.positive,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DashboardMetricCard(
                  icon: Icons.trending_up_rounded,
                  title: 'Est. Profit',
                  value: isEmpty
                      ? '—'
                      : isPartial
                      ? 'Not enough data'
                      : 'Rs 7,650',
                  comparison: isEmpty || isPartial ? null : '↓ 2.1%',
                  subtitle: isPartial ? 'Add Expenses' : null,
                  status: MetricStatus.negative,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: DashboardMetricCard(
                  icon: Icons.restaurant_outlined,
                  title: 'Food Cost',
                  value: isEmpty || isPartial ? '—' : '28.4%',
                  subtitle: isEmpty || isPartial ? null : 'Target < 30%',
                  status: MetricStatus.warning,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
