import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    required this.onAddOrder,
    required this.onAddExpense,
    required this.onRecordWastage,
    super.key,
  });

  final VoidCallback onAddOrder;
  final VoidCallback onAddExpense;
  final VoidCallback onRecordWastage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _QuickAction(
                icon: Icons.add_chart_rounded,
                label: 'Add Order',
                onTap: onAddOrder,
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
            Expanded(
              child: _QuickAction(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Add Expense',
                onTap: onAddExpense,
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
            Expanded(
              child: _QuickAction(
                icon: Icons.delete_outline_rounded,
                label: 'Record Wastage',
                onTap: onRecordWastage,
                isWarning: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isWarning = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final color = isWarning ? const Color(0xFFB45309) : AppColors.primary;

    return Material(
      color: isWarning
          ? const Color(0xFFFFF4E5)
          : AppColors.splashAccent.withValues(alpha: 0.32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: color.withValues(alpha: 0.14)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceXs,
            vertical: AppSpacing.spaceSm,
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 23),
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
