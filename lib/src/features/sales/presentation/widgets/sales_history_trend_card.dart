import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_card.dart';

import 'sales_history_data.dart';

class SalesHistoryTrendCard extends StatelessWidget {
  const SalesHistoryTrendCard({
    required this.points,
    required this.grouping,
    super.key,
  });

  final List<SalesHistoryTrendPoint> points;
  final SalesTrendGrouping grouping;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Sales Trend',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                _groupingLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Semantics(
            label: _semanticLabel,
            child: ExcludeSemantics(
              child: SizedBox(
                height: 140,
                child: BarChart(
                  _chartData(context),
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _groupingLabel => switch (grouping) {
    SalesTrendGrouping.daily => 'Daily',
    SalesTrendGrouping.weekly => 'Weekly',
    SalesTrendGrouping.monthly => 'Monthly',
  };

  BarChartData _chartData(BuildContext context) {
    final highestValue = points.map((point) => point.value).reduce(math.max);
    final interval = _axisInterval(highestValue);
    final maxY = math.max(
      interval,
      (highestValue / interval).ceil() * interval,
    );
    final barWidth = switch (points.length) {
      >= 24 => 5.0,
      >= 12 => 8.0,
      >= 7 => 13.0,
      _ => 20.0,
    };

    return BarChartData(
      minY: 0,
      maxY: maxY,
      alignment: BarChartAlignment.spaceAround,
      groupsSpace: points.length >= 12 ? 3 : 8,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: interval,
        getDrawingHorizontalLine: (_) => FlLine(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: .5),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles()),
        rightTitles: const AxisTitles(sideTitles: SideTitles()),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 34,
            interval: interval,
            minIncluded: false,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              meta: meta,
              space: 6,
              child: Text(
                _compactValue(value),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= points.length) {
                return const SizedBox.shrink();
              }
              final labelStep = points.length > 20 ? 5 : 2;
              final shouldShowLabel =
                  points.length <= 12 ||
                  index == 0 ||
                  index == points.length - 1 ||
                  index % labelStep == 0;
              if (!shouldShowLabel) return const SizedBox.shrink();
              return SideTitleWidget(
                meta: meta,
                space: 6,
                child: Text(
                  points[index].label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: points.length >= 12 ? 8 : 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceSm,
            vertical: AppSpacing.spaceXs,
          ),
          tooltipMargin: AppSpacing.spaceXs,
          tooltipBorderRadius: BorderRadius.circular(AppRadius.sm),
          getTooltipColor: (_) => AppColors.primary,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final point = points[group.x];
            return BarTooltipItem(
              '${point.tooltipLabel}\nRs '
              '${NumberFormat.decimalPattern().format(point.value)}',
              const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
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
                toY: points[index].value,
                width: barWidth,
                color: AppColors.primary.withValues(alpha: .78),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xs),
                ),
              ),
            ],
          ),
      ],
    );
  }

  double _axisInterval(double maxValue) {
    if (maxValue <= 50000) return 10000;
    if (maxValue <= 250000) return 50000;
    return 200000;
  }

  String _compactValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    return '${(value / 1000).round()}K';
  }

  String get _semanticLabel {
    final currency = NumberFormat.decimalPattern();
    final values = points
        .map(
          (point) =>
              '${point.tooltipLabel}: Rs ${currency.format(point.value)}',
        )
        .join(', ');
    return 'Sales trend grouped $_groupingLabel. $values';
  }
}
