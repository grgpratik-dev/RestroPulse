import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final total = categories.fold<double>(
      0,
      (sum, category) => sum + category.amount,
    );
    const colors = [
      Color(0xFFE38B2C),
      Color(0xFF047857),
      Color(0xFF5C6BC0),
      Color(0xFF00ACC1),
      Color(0xFFB7791F),
      Color(0xFF94A3B8),
    ];
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
          child: Column(
            children: [
              SizedBox(
                height: 210,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        centerSpaceRadius: 58,
                        sectionsSpace: 3,
                        startDegreeOffset: -90,
                        pieTouchData: PieTouchData(enabled: true),
                        sections: [
                          for (
                            var index = 0;
                            index < categories.length;
                            index++
                          )
                            PieChartSectionData(
                              value: categories[index].amount,
                              color: colors[index % colors.length],
                              radius: 42,
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
                        const SizedBox(height: 3),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Rs ${currency.format(total)}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.spaceSm),
              const Divider(),
              const SizedBox(height: AppSpacing.spaceXs),
              for (var index = 0; index < categories.length; index++) ...[
                InkWell(
                  onTap: () => onCategoryTap(categories[index]),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colors[index % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spaceSm),
                        Expanded(
                          child: Text(
                            categories[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          'Rs ${currency.format(categories[index].amount)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 34,
                          child: Text(
                            '${(categories[index].percentage * 100).round()}%',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, size: 19),
                      ],
                    ),
                  ),
                ),
                if (index != categories.length - 1)
                  const Divider(height: AppSpacing.spaceMd),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
