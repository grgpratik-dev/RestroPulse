import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../domain/models/expense.dart';
import 'expense_category_icon.dart';

class RecentExpensesList extends StatelessWidget {
  const RecentExpensesList({
    required this.expenses,
    required this.onExpenseTap,
    required this.onViewHistory,
    super.key,
  });

  final List<Expense> expenses;
  final ValueChanged<Expense> onExpenseTap;
  final VoidCallback onViewHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent Expenses',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: onViewHistory,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View History'),
                  SizedBox(width: 2),
                  SvgPicture.asset(
                    AppIcons.arrow_forward_rounded,
                    width: 18,
                    height: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        if (expenses.isEmpty)
          const AppCard(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.spaceLg),
                child: Text('No expenses match these filters.'),
              ),
            ),
          )
        else
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spaceSm,
              vertical: AppSpacing.spaceXs,
            ),
            child: Column(
              children: [
                for (var index = 0; index < expenses.length; index++) ...[
                  _ExpenseRow(
                    expense: expenses[index],
                    onTap: () => onExpenseTap(expenses[index]),
                  ),
                  if (index != expenses.length - 1) const AppDivider(height: 1),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.expense, required this.onTap});

  final Expense expense;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceSm),
        child: Row(
          children: [
            ExpenseCategoryIcon(category: expense.category),
            const SizedBox(width: AppSpacing.spaceSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${expense.category} · ${_dateLabel(expense.date)} · '
                    '${DateFormat.jm().format(expense.date)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.type.label,
                    style: const TextStyle(
                      color: AppColors.expenseForeground,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
            Text(
              'Rs ${currency.format(expense.amount)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            SvgPicture.asset(
              AppIcons.chevron_right_rounded,
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _dateLabel(DateTime date) {
    if (date.year == 2026 && date.month == 8 && date.day == 16) {
      return 'Today';
    }
    return DateFormat('MMM d').format(date);
  }
}
