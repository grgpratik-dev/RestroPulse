import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/expense.dart';
import 'expense_category_icon.dart';

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
              for (var index = 0; index < categories.length; index++) ...[
                InkWell(
                  onTap: () => onCategoryTap(categories[index]),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        ExpenseCategoryIcon(
                          category: categories[index].name,
                          size: 42,
                        ),
                        const SizedBox(width: AppSpacing.spaceSm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      categories[index].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Rs ${currency.format(categories[index].amount)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
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
                                ],
                              ),
                              const SizedBox(height: 7),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: categories[index].percentage,
                                  minHeight: 7,
                                  color: const Color(0xFFE38B2C),
                                  backgroundColor: const Color(0xFFFFF2DF),
                                ),
                              ),
                            ],
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
