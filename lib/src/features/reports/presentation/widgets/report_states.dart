import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';

class ReportsEmptyState extends StatelessWidget {
  const ReportsEmptyState({
    required this.onAddOrder,
    required this.onAddExpense,
    super.key,
  });

  final VoidCallback onAddOrder;
  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) {
    return _ReportState(
      icon: Icons.analytics_outlined,
      title: 'Not enough data for reports yet',
      message: 'Keep recording orders and expenses to unlock deeper insights.',
      actions: [
        FilledButton(onPressed: onAddOrder, child: const Text('Add Order')),
        OutlinedButton(
          onPressed: onAddExpense,
          child: const Text('Add Expense'),
        ),
      ],
    );
  }
}

class ReportsErrorState extends StatelessWidget {
  const ReportsErrorState({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _ReportState(
      icon: Icons.cloud_off_rounded,
      title: "Couldn't load reports",
      message: 'Check your connection and try again.',
      actions: [
        FilledButton(onPressed: onRetry, child: const Text('Try Again')),
      ],
    );
  }
}

class ReportsLoadingSkeleton extends StatelessWidget {
  const ReportsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Column(
      children: [
        _Skeleton(height: 245, color: color),
        const SizedBox(height: AppSpacing.spaceMd),
        _Skeleton(height: 260, color: color),
        const SizedBox(height: AppSpacing.spaceMd),
        _Skeleton(height: 180, color: color),
        const SizedBox(height: AppSpacing.spaceMd),
        _Skeleton(height: 210, color: color),
      ],
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _ReportState extends StatelessWidget {
  const _ReportState({
    required this.icon,
    required this.title,
    required this.message,
    required this.actions,
  });

  final IconData icon;
  final String title;
  final String message;
  final List<Widget> actions;

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
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
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
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              for (var index = 0; index < actions.length; index++) ...[
                SizedBox(width: double.infinity, child: actions[index]),
                if (index != actions.length - 1)
                  const SizedBox(height: AppSpacing.spaceXs),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
