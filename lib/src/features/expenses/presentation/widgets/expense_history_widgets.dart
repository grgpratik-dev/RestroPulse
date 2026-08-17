import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/expense.dart';
import 'expense_category_icon.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class ExpenseHistorySummary extends StatelessWidget {
  const ExpenseHistorySummary({
    required this.rangeLabel,
    required this.total,
    required this.transactions,
    super.key,
  });

  final String rangeLabel;
  final double total;
  final int transactions;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return CustomContainer(
      color: AppColors.expenseForeground,
      borderColor: AppColors.expenseForeground,
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rangeLabel,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.surface.withValues(alpha: .72),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'Rs ${currency.format(total)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            '$transactions ${transactions == 1 ? 'transaction' : 'transactions'}',
            style: TextStyle(
              color: AppColors.surface.withValues(alpha: .78),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseHistoryGroup extends StatelessWidget {
  const ExpenseHistoryGroup({
    required this.date,
    required this.expenses,
    required this.onExpenseTap,
    super.key,
  });

  final DateTime date;
  final List<Expense> expenses;
  final ValueChanged<Expense> onExpenseTap;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final total = expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _dateLabel(date),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              'Rs ${currency.format(total)}',
              style: const TextStyle(
                color: AppColors.expenseForeground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        CustomContainer(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceSm,
            vertical: AppSpacing.space2xs,
          ),
          child: Column(
            children: [
              for (var index = 0; index < expenses.length; index++) ...[
                _HistoryExpenseRow(
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

  String _dateLabel(DateTime value) {
    if (value.year == 2026 && value.month == 8 && value.day == 16) {
      return 'Today · Aug 16';
    }
    return DateFormat('EEEE, MMM d').format(value);
  }
}

class ExpenseHistoryEmptyState extends StatelessWidget {
  const ExpenseHistoryEmptyState({required this.onChangeFilters, super.key});

  final VoidCallback onChangeFilters;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceXl),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.expenseSurface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const AppIcon(
                AppIcons.receipt_long_outlined,
                color: AppColors.expenseForeground,
                size: 30,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            Text(
              'No expenses found',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.space2xs),
            Text(
              'Try another date range or clear your filters.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            OutlinedButton(
              onPressed: onChangeFilters,
              child: const Text('Change filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryExpenseRow extends StatelessWidget {
  const _HistoryExpenseRow({required this.expense, required this.onTap});

  final Expense expense;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
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
                    '${expense.category} · ${expense.type.label}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
            Text(
              'Rs ${currency.format(expense.amount)}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const AppIcon(AppIcons.chevron_right_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
