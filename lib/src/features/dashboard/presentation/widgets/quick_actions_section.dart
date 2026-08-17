import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

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
        Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.spaceSm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _QuickAction(
                icon: AppIcons.add_chart_rounded,
                label: 'Add Order',
                onTap: onAddOrder,
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
            Expanded(
              child: _QuickAction(
                icon: AppIcons.expenseAdd,
                label: 'Add Expense',
                onTap: onAddExpense,
                tone: _QuickActionTone.expense,
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
            Expanded(
              child: _QuickAction(
                icon: AppIcons.wastage,
                label: 'Record Wastage',
                onTap: onRecordWastage,
                tone: _QuickActionTone.warning,
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
    this.tone = _QuickActionTone.positive,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final _QuickActionTone tone;

  @override
  Widget build(BuildContext context) {
    final (foreground, background, border) = switch (tone) {
      _QuickActionTone.positive => (
        AppColors.primary,
        AppColors.splashAccent.withValues(alpha: 0.32),
        AppColors.primary.withValues(alpha: 0.14),
      ),
      _QuickActionTone.expense => (
        AppColors.expenseForeground,
        AppColors.expenseSurface,
        AppColors.expenseBorder,
      ),
      _QuickActionTone.warning => (
        AppColors.warning,
        AppColors.warningSoft,
        AppColors.warning.withValues(alpha: 0.14),
      ),
    };

    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: border),
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
              AppIcon(icon, color: foreground, size: 23),
              const SizedBox(height: AppSpacing.spaceXs),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: foreground,
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

enum _QuickActionTone { positive, expense, warning }
