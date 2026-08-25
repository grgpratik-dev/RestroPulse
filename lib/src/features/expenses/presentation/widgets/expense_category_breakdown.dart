import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
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
    AppColors.expenseAccent,
    AppColors.primaryStrong,
    AppColors.secondary,
    AppColors.accent,
    AppColors.expenseForeground,
    AppColors.neutral500,
  ];

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
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.spaceMd),
          child: Column(
            children: [
              for (var index = 0; index < categories.length; index++) ...[
                _CategoryProgressRow(
                  category: categories[index],
                  color: _colors[index % _colors.length],
                  formattedAmount:
                      'Rs ${currency.format(categories[index].amount)}',
                  onTap: () => onCategoryTap(categories[index]),
                ),
                if (index != categories.length - 1)
                  const SizedBox(height: AppSpacing.spaceMd),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryProgressRow extends StatelessWidget {
  const _CategoryProgressRow({
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
    final percentage = (category.percentage * 100).round();

    return Semantics(
      button: true,
      label: '${category.name}, $percentage percent, $formattedAmount',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2xs),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  Text(
                    formattedAmount,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: AppSpacing.spaceXs),
                  SizedBox(
                    width: 34,
                    child: Text(
                      '$percentage%',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space2xs),
                  SvgPicture.asset(
                    AppIcons.chevron_right_rounded,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurfaceVariant,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: category.percentage.clamp(0, 1),
                  minHeight: 7,
                  backgroundColor: AppColors.neutral200,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
