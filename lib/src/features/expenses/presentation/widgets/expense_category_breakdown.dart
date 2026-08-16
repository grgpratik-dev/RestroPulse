import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/expense.dart';

class ExpenseCategoryBreakdown extends StatelessWidget {
  const ExpenseCategoryBreakdown({
    required this.categories,
    required this.onCategoryTap,
    super.key,
  });

  final List<ExpenseCategorySummary> categories;
  final ValueChanged<ExpenseCategorySummary> onCategoryTap;

  static const _colors = [
    AppColors.warningChart,
    AppColors.primaryStrong,
    AppColors.secondary,
    AppColors.accent,
    AppColors.amberDark,
    AppColors.neutral500,
  ];

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final total = categories.fold<double>(
      0,
      (sum, category) => sum + category.amount,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where Money Went',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        CustomContainer(
          padding: const EdgeInsets.all(AppSpacing.spaceMd),
          child: Column(
            children: [
              SizedBox(
                height: 168,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        centerSpaceRadius: 46,
                        sectionsSpace: 3,
                        startDegreeOffset: -90,
                        pieTouchData: PieTouchData(enabled: false),
                        sections: [
                          for (
                            var index = 0;
                            index < categories.length;
                            index++
                          )
                            PieChartSectionData(
                              value: categories[index].amount,
                              color: _colors[index % _colors.length],
                              radius: 32,
                              showTitle: false,
                            ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 350),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rs ${currency.format(total)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: AppSpacing.spaceLg),
              for (var index = 0; index < categories.length; index++) ...[
                _CategoryRow(
                  category: categories[index],
                  color: _colors[index % _colors.length],
                  formattedAmount:
                      'Rs ${currency.format(categories[index].amount)}',
                  onTap: () => onCategoryTap(categories[index]),
                ),
                if (index != categories.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.color,
    required this.formattedAmount,
    required this.onTap,
  });

  final ExpenseCategorySummary category;
  final Color color;
  final String formattedAmount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          '${category.name}, ${(category.percentage * 100).round()} percent, $formattedAmount',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceSm),
          child: Row(
            children: [
              Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${(category.percentage * 100).round()}% of total',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Text(
                formattedAmount,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
