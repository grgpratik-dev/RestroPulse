import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/models/expense.dart';

class ExpenseTrendCard extends StatelessWidget {
  const ExpenseTrendCard({
    required this.period,
    required this.points,
    super.key,
  });

  final ExpensePeriod period;
  final List<ExpenseTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final highest = points.reduce((a, b) => a.amount >= b.amount ? a : b);
    final maximum = highest.amount * 1.25;
    final axisInterval = _axisInterval(maximum);
    final currency = NumberFormat.decimalPattern();
    final highestLabel = switch (period) {
      ExpensePeriod.week => 'Highest day',
      ExpensePeriod.month => 'Highest week',
      ExpensePeriod.quarter ||
      ExpensePeriod.sixMonths ||
      ExpensePeriod.year => 'Highest month',
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expense Trend',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          SizedBox(
            height: 210,
            child: BarChart(
              BarChartData(
                maxY: maximum,
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: axisInterval,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    strokeWidth: 0.7,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      interval: axisInterval,
                      getTitlesWidget: (value, meta) {
                        final isInterval =
                            ((value / axisInterval) -
                                    (value / axisInterval).round())
                                .abs() <
                            0.001;
                        if (value == 0 || !isInterval) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          space: 6,
                          child: Text(
                            '${value.round()}k',
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
                        final show = points.length <= 7 || index.isEven;
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            show ? points[index].label : '',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.ink,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final point = points[group.x];
                      final multiplier = period == ExpensePeriod.week
                          ? 1000
                          : 1000;
                      return BarTooltipItem(
                        '${point.tooltipLabel}\nRs ${currency.format(point.amount * multiplier)}',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                barGroups: [
                  for (var index = 0; index < points.length; index++)
                    BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: points[index].amount,
                          width: points.length > 7 ? 10 : 18,
                          color: AppColors.expenseAccent,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.spaceSm),
            decoration: BoxDecoration(
              color: AppColors.expenseSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.bar_chart_rounded,
                  colorFilter: const ColorFilter.mode(
                    AppColors.expenseForeground,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceXs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        highestLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${highest.tooltipLabel} · Rs ${currency.format(highest.amount * 1000)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _axisInterval(double maximum) {
    if (maximum <= 40) return 10;
    if (maximum <= 200) return 50;
    if (maximum <= 800) return 200;
    return 500;
  }
}
