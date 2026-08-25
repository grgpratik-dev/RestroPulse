import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_state_message.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class ExpensesEmptyState extends StatelessWidget {
  const ExpensesEmptyState({required this.onAddExpense, super.key});

  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) => AppStateMessage(
    icon: AppIcons.receipt_long_outlined,
    title: 'No expenses recorded yet',
    message:
        "Add your restaurant's expenses to understand costs and estimate profitability.",
    iconBackgroundColor: AppColors.expenseSurface,
    iconColor: AppColors.expenseForeground,
    actions: [
      FilledButton(onPressed: onAddExpense, child: const Text('Add Expense')),
    ],
  );
}

class ExpensesNoPeriodState extends StatelessWidget {
  const ExpensesNoPeriodState({required this.onAddExpense, super.key});

  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) => AppStateMessage(
    icon: AppIcons.event_busy_outlined,
    title: 'No expenses this month',
    message: 'Add an expense to start tracking this month’s spending.',
    iconBackgroundColor: AppColors.expenseSurface,
    iconColor: AppColors.expenseForeground,
    actions: [
      FilledButton(onPressed: onAddExpense, child: const Text('Add Expense')),
    ],
  );
}

class ExpensesErrorState extends StatelessWidget {
  const ExpensesErrorState({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => AppStateMessage(
    icon: AppIcons.cloud_off_rounded,
    title: "Couldn't load expenses",
    message: 'Check your connection and try again.',
    iconBackgroundColor: AppColors.expenseSurface,
    iconColor: AppColors.expenseForeground,
    actions: [FilledButton(onPressed: onRetry, child: const Text('Try Again'))],
  );
}

class ExpensesLoadingSkeleton extends StatelessWidget {
  const ExpensesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AppSkeleton(height: 250),
        SizedBox(height: AppSpacing.spaceMd),
        AppSkeleton(height: 360),
        SizedBox(height: AppSpacing.spaceMd),
        AppSkeleton(height: 280),
      ],
    );
  }
}
