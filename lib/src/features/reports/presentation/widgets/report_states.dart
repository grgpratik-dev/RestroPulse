import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_state_message.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

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
    return AppStateMessage(
      icon: AppIcons.analytics_outlined,
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
    return AppStateMessage(
      icon: AppIcons.cloud_off_rounded,
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
    return const Column(
      children: [
        AppSkeleton(height: 245),
        SizedBox(height: AppSpacing.spaceMd),
        AppSkeleton(height: 260),
        SizedBox(height: AppSpacing.spaceMd),
        AppSkeleton(height: 180),
        SizedBox(height: AppSpacing.spaceMd),
        AppSkeleton(height: 210),
      ],
    );
  }
}
