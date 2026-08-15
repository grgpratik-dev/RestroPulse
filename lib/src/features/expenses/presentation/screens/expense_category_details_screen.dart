import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/expense.dart';
import '../widgets/expense_category_icon.dart';

class ExpenseCategoryDetailsScreen extends StatelessWidget {
  const ExpenseCategoryDetailsScreen({required this.category, super.key});

  final ExpenseCategorySummary category;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final related = ExpensesMockData.expenses
        .where((expense) => expense.category == category.name)
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            CustomContainer(
              child: Column(
                children: [
                  Row(
                    children: [
                      ExpenseCategoryIcon(category: category.name, size: 58),
                      const SizedBox(width: AppSpacing.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total spent',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              'Rs ${currency.format(category.amount)}',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spaceLg),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          label: 'Transactions',
                          value: '${category.transactionCount}',
                        ),
                      ),
                      Expanded(
                        child: _Metric(
                          label: 'Share of expenses',
                          value: '${(category.percentage * 100).round()}%',
                        ),
                      ),
                      Expanded(
                        child: _Metric(
                          label: 'Comparison',
                          value:
                              '${category.change >= 0 ? '↑' : '↓'} ${category.change.abs().toStringAsFixed(1)}%',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly trend',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  SizedBox(
                    height: 150,
                    child: BarChart(
                      BarChartData(
                        maxY: 60,
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barGroups: [
                          for (var index = 0; index < 6; index++)
                            BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: [
                                    32,
                                    38,
                                    35,
                                    44,
                                    51,
                                    48,
                                  ][index].toDouble(),
                                  width: 18,
                                  color: const Color(0xFFE38B2C),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(5),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            Text(
              'Recent ${category.name.toLowerCase()} expenses',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            if (related.isEmpty)
              const CustomContainer(
                child: Text('No recent transactions in the sample data.'),
              )
            else
              for (final expense in related)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(expense.description),
                  subtitle: Text(
                    DateFormat('MMM d, yyyy').format(expense.date),
                  ),
                  trailing: Text(
                    'Rs ${currency.format(expense.amount)}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
    ],
  );
}
