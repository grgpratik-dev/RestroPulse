import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final interval = _axisInterval(maxValue);
    final maxY = (maxValue / interval).ceil() * interval;
    final currency = NumberFormat.decimalPattern();
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue vs Expenses',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          const Wrap(
            spacing: AppSpacing.spaceSm,
            runSpacing: 4,
            children: [
              _Legend(color: AppColors.primary, label: 'Revenue'),
              _Legend(color: AppColors.amber, label: 'Expenses'),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          SizedBox(
            height: 210,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    strokeWidth: 0.7,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.ink,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final point = points[group.x];
                      final label = rodIndex == 0 ? 'Revenue' : 'Expenses';
                      return BarTooltipItem(
                        '${point.label}\n$label · Rs ${currency.format(rod.toY * 1000)}',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return SideTitleWidget(
                          meta: meta,
                          space: 6,
                          child: Text(
                            _axisLabel(value),
                            maxLines: 1,
                            softWrap: false,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        );
                      },
                    ),
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
                          color: AppColors.amber,
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

  double _axisInterval(double maximum) {
    if (maximum <= 60) return 10;
    if (maximum <= 350) return 100;
    if (maximum <= 1200) return 250;
    return 500;
  }

  String _axisLabel(double value) {
    if (value < 1000) return '${value.round()}k';
    final millions = value / 1000;
    final digits = millions == millions.roundToDouble() ? 0 : 1;
    return '${millions.toStringAsFixed(digits)}M';
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
