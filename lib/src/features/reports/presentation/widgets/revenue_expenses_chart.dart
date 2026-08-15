import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/report_data.dart';

class RevenueExpensesChart extends StatelessWidget {
  const RevenueExpensesChart({required this.points, super.key});

  final List<ReportChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final maxValue = points.fold<double>(
      0,
      (maximum, point) => [
        maximum,
        point.revenue,
        point.expenses,
      ].reduce((a, b) => a > b ? a : b),
    );
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Revenue vs Expenses',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const _Legend(color: AppColors.primary, label: 'Revenue'),
              const SizedBox(width: AppSpacing.spaceSm),
              const _Legend(color: Color(0xFFF59E0B), label: 'Expenses'),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          SizedBox(
            height: 210,
            child: BarChart(
              BarChartData(
                maxY: maxValue * 1.2,
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: maxValue <= 0 ? 1 : maxValue / 4,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    strokeWidth: 0.7,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= points.length) {
                          return const SizedBox.shrink();
                        }
                        final showLabel = points.length <= 7 || index.isEven;
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            showLabel ? points[index].label : '',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var index = 0; index < points.length; index++)
                    BarChartGroupData(
                      x: index,
                      barsSpace: 3,
                      barRods: [
                        BarChartRodData(
                          toY: points[index].revenue,
                          width: points.length > 7 ? 6 : 11,
                          color: AppColors.primary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: points[index].expenses,
                          width: points.length > 7 ? 6 : 11,
                          color: const Color(0xFFF59E0B),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
