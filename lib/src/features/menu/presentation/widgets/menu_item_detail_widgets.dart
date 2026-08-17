import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/menu_item.dart';
import 'menu_performance_chip.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class MenuItemHeader extends StatelessWidget {
  const MenuItemHeader({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: AppColors.mintSoft,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const AppIcon(
            AppIcons.restaurant_menu_rounded,
            color: AppColors.primary,
            size: 36,
          ),
        ),
        const SizedBox(width: AppSpacing.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.category,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MenuPricingCard extends StatelessWidget {
  const MenuPricingCard({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(
                child: DetailMetric(
                  label: 'Selling price',
                  value: 'Rs ${currency.format(item.sellingPrice)}',
                ),
              ),
              Expanded(
                child: DetailMetric(
                  label: 'Estimated cost',
                  value: 'Rs ${currency.format(item.estimatedCost)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(
                child: DetailMetric(
                  label: 'Food cost',
                  value: '${item.foodCostPercentage.toStringAsFixed(1)}%',
                ),
              ),
              Expanded(
                child: DetailMetric(
                  label: 'Contribution',
                  value: 'Rs ${currency.format(item.contributionPerUnit)}',
                  positive: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuPerformanceCard extends StatelessWidget {
  const MenuPerformanceCard({
    required this.item,
    this.periodLabel = '1M · August 2026',
    super.key,
  });

  final MenuItem item;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    if (item.unitsSold == 0) {
      return const CustomContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.spaceLg),
          child: Center(
            child: Column(
              children: [
                AppIcon(
                  AppIcons.bar_chart_rounded,
                  size: 38,
                  color: AppColors.primary,
                ),
                SizedBox(height: AppSpacing.spaceSm),
                Text(
                  'No sales recorded yet',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text('Performance will appear after this item is sold.'),
              ],
            ),
          ),
        ),
      );
    }

    final currency = NumberFormat.decimalPattern();
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Performance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spaceSm,
                  vertical: AppSpacing.spaceXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  periodLabel,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Row(
            children: [
              Expanded(
                child: DetailMetric(
                  label: 'Units sold',
                  value: '${item.unitsSold}',
                ),
              ),
              Expanded(
                child: DetailMetric(
                  label: 'Revenue',
                  value: 'Rs ${currency.format(item.revenue)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(
                child: DetailMetric(
                  label: 'Estimated cost',
                  value: 'Rs ${currency.format(item.estimatedHistoricalCost)}',
                ),
              ),
              Expanded(
                child: DetailMetric(
                  label: 'Contribution',
                  value:
                      'Rs ${currency.format(item.estimatedHistoricalContribution)}',
                  positive: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          DetailMetric(
            label: 'Orders containing item',
            value: '${item.ordersContainingItem}',
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          const SizedBox(height: 150, child: _PerformanceChart()),
          const SizedBox(height: AppSpacing.spaceSm),
          const Text(
            '↑ 8.4% units sold compared with last month',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Calculated from prices and costs saved on each order item.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuClassificationCard extends StatelessWidget {
  const MenuClassificationCard({
    required this.item,
    this.demandMultiplier = 1,
    super.key,
  });

  final MenuItem item;
  final double demandMultiplier;

  @override
  Widget build(BuildContext context) {
    final status = MenuPerformanceClassifier.classify(
      item,
      demandMultiplier: demandMultiplier,
    );
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Menu performance',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          MenuPerformanceChip(status: status),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            status.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(status.description),
          const SizedBox(height: AppSpacing.spaceMd),
          Container(
            padding: const EdgeInsets.all(AppSpacing.spaceSm),
            decoration: BoxDecoration(
              color: AppColors.mintSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppIcon(
                  AppIcons.lightbulb_outline_rounded,
                  color: AppColors.primary,
                  size: 21,
                ),
                const SizedBox(width: AppSpacing.spaceXs),
                Expanded(child: Text(status.recommendation)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailMetric extends StatelessWidget {
  const DetailMetric({
    required this.label,
    required this.value,
    this.positive = false,
    super.key,
  });

  final String label;
  final String value;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: positive ? AppColors.primary : null,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PerformanceChart extends StatelessWidget {
  const _PerformanceChart();

  static const _values = [24.0, 31.0, 28.0, 43.0];

  @override
  Widget build(BuildContext context) {
    final values = _values;
    final maximum = values.reduce((a, b) => a > b ? a : b) * 1.25;
    return BarChart(
      BarChartData(
        maxY: maximum,
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barTouchData: BarTouchData(enabled: false),
        barGroups: [
          for (var index = 0; index < values.length; index++)
            BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: values[index],
                  width: values.length > 8 ? 9 : 16,
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5),
                  ),
                ),
              ],
            ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
    );
  }
}
