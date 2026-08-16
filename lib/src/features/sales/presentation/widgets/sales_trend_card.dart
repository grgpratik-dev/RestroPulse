import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_trend_data.dart';

class SalesTrendCard extends StatelessWidget {
  const SalesTrendCard({this.period = SalesTrendPeriod.week, super.key});

  final SalesTrendPeriod period;

  SalesTrendDataset get _dataset => SalesTrendAggregator.prepare(
    orders: SalesTrendMockOrders.values,
    period: period,
    now: SalesTrendMockOrders.currentDate,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataset = _dataset;

    return CustomContainer(
      borderRadius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sales Trend',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      period.dateLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spaceSm,
                  vertical: AppSpacing.spaceXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  period.chartContext,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _TrendSummary(dataset: dataset),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Semantics(
            label: _semanticLabel(dataset),
            child: ExcludeSemantics(
              child: Container(
                height: 210,
                padding: const EdgeInsets.only(
                  top: AppSpacing.spaceSm,
                  right: AppSpacing.space2xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.splashAccent.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: BarChart(
                  _chartData(context, dataset),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartData _chartData(BuildContext context, SalesTrendDataset dataset) {
    final values = dataset.points.map((point) => point.value).toList();
    final highestValue = values.reduce(math.max);
    final interval = _axisInterval(highestValue);
    final maxY = math.max(
      interval,
      (highestValue / interval).ceil() * interval,
    );
    final barWidth = switch (dataset.points.length) {
      >= 12 => 10.0,
      >= 7 => 15.0,
      _ => 21.0,
    };

    return BarChartData(
      minY: 0,
      maxY: maxY,
      alignment: BarChartAlignment.spaceAround,
      groupsSpace: dataset.points.length >= 12 ? 3 : 8,
      backgroundColor: Colors.transparent,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: interval,
        getDrawingHorizontalLine: (_) => FlLine(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: .45),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles()),
        rightTitles: const AxisTitles(sideTitles: SideTitles()),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            interval: interval,
            minIncluded: false,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                meta: meta,
                space: 6,
                child: Text(
                  _compactValue(value),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 9.5,
                  ),
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= dataset.points.length) {
                return const SizedBox.shrink();
              }
              return SideTitleWidget(
                meta: meta,
                space: 7,
                child: Text(
                  dataset.points[index].label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: dataset.points.length >= 12 ? 8.5 : 10,
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
        handleBuiltInTouches: true,
        touchExtraThreshold: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceXs,
          vertical: AppSpacing.space2xs,
        ),
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
            final point = dataset.points[group.x];
            return BarTooltipItem(
              '${point.tooltipLabel}\n',
              const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text:
                      'Rs ${NumberFormat.decimalPattern().format(point.value)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      barGroups: [
        for (var index = 0; index < dataset.points.length; index++)
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: dataset.points[index].value,
                width: barWidth,
                color: dataset.points[index] == dataset.bestPoint
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: .7),
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
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M';
    }
    return '${(value / 1000).round()}K';
  }

  String _semanticLabel(SalesTrendDataset dataset) {
    final currency = NumberFormat.decimalPattern();
    final values = dataset.points
        .map((point) {
          return '${point.tooltipLabel}: Rs ${currency.format(point.value)}';
        })
        .join(', ');
    return 'Sales trend for ${period.dateLabel}. $values';
  }
}

class _TrendSummary extends StatelessWidget {
  const _TrendSummary({required this.dataset});

  final SalesTrendDataset dataset;

  @override
  Widget build(BuildContext context) {
    final best = dataset.bestPoint;
    final currency = NumberFormat.decimalPattern();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          dataset.summaryTitle,
          style: const TextStyle(fontSize: 11, color: AppColors.primary),
        ),
        Text(
          best.summaryLabel ?? best.tooltipLabel,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
        Text(
          'Rs ${currency.format(best.value)}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
