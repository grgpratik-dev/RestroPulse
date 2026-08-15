import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

class ExpensesEmptyState extends StatelessWidget {
  const ExpensesEmptyState({required this.onAddExpense, super.key});

  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) => _StateContent(
    icon: Icons.receipt_long_outlined,
    title: 'No expenses recorded yet',
    message:
        "Add your restaurant's expenses to understand costs and estimate profitability.",
    actionLabel: 'Add Expense',
    onAction: onAddExpense,
  );
}

class ExpensesNoPeriodState extends StatelessWidget {
  const ExpensesNoPeriodState({required this.onAddExpense, super.key});

  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) => _StateContent(
    icon: Icons.event_busy_outlined,
    title: 'No expenses in this period',
    message: 'Try another time range or add a new expense.',
    actionLabel: 'Add Expense',
    onAction: onAddExpense,
  );
}

class ExpensesErrorState extends StatelessWidget {
  const ExpensesErrorState({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => _StateContent(
    icon: Icons.cloud_off_rounded,
    title: "Couldn't load expenses",
    message: 'Check your connection and try again.',
    actionLabel: 'Try Again',
    onAction: onRetry,
  );
}

class ExpensesLoadingSkeleton extends StatelessWidget {
  const ExpensesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Column(
      children: [
        _Skeleton(height: 250, color: color),
        const SizedBox(height: AppSpacing.spaceMd),
        _Skeleton(height: 360, color: color),
        const SizedBox(height: AppSpacing.spaceMd),
        _Skeleton(height: 280, color: color),
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.height, required this.color});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

class _StateContent extends StatelessWidget {
  const _StateContent({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 330),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFFFFF2DF),
                child: Icon(icon, color: const Color(0xFFB45309), size: 32),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              FilledButton(onPressed: onAction, child: Text(actionLabel)),
            ],
          ),
        ),
      ),
    );
  }
}
