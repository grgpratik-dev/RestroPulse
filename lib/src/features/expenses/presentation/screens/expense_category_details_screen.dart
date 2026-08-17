import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/expense.dart';
import '../widgets/expense_category_icon.dart';
import '../widgets/expense_detail_widgets.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class ExpenseCategoryDetailsScreen extends StatelessWidget {
  const ExpenseCategoryDetailsScreen({
    required this.category,
    required this.period,
    super.key,
  });

  final ExpenseCategorySummary category;
  final ExpensePeriod period;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final related = ExpensesMockData.expenses
        .where((expense) => expense.category == category.name)
        .toList();
    final trend = ExpensesMockData.categoryTrend(category, period);
    final maximum =
        trend.fold<double>(
          0,
          (value, point) => point.amount > value ? point.amount : value,
        ) *
        1.25;
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
                        child: ExpenseDetailMetric(
                          label: 'Transactions',
                          value: '${category.transactionCount}',
                        ),
                      ),
                      Expanded(
                        child: ExpenseDetailMetric(
                          label: 'Share of expenses',
                          value: '${(category.percentage * 100).round()}%',
                        ),
                      ),
                      Expanded(
                        child: ExpenseDetailMetric(
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
                    '${period.label} category trend',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  SizedBox(
                    height: 150,
                    child: BarChart(
                      BarChartData(
                        maxY: maximum,
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
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
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= trend.length) {
                                  return const SizedBox.shrink();
                                }
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text(
                                    trend[index].label,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        barGroups: [
                          for (var index = 0; index < trend.length; index++)
                            BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: trend[index].amount,
                                  width: trend.length > 7 ? 10 : 18,
                                  color: AppColors.expenseAccent,
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
                  onTap: () => context.pushNamed(
                    AppRoute.expenseDetails.name,
                    extra: expense,
                  ),
                  title: Text(expense.description),
                  subtitle: Text(
                    DateFormat('MMM d, yyyy').format(expense.date),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Rs ${currency.format(expense.amount)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 4),
                      const AppIcon(AppIcons.chevron_right_rounded, size: 20),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
