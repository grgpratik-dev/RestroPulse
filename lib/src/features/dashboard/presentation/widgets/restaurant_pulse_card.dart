import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';

import 'restaurant_pulse_heart.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class RestaurantPulseCard extends StatelessWidget {
  const RestaurantPulseCard({
    required this.hasData,
    required this.onAddOrder,
    required this.onAddExpense,
    super.key,
  });

  final bool hasData;
  final VoidCallback onAddOrder;
  final VoidCallback onAddExpense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomContainer(
      color: hasData ? AppColors.primaryStrong : AppColors.surface,
      borderColor: hasData
          ? AppColors.primaryStrong
          : AppColors.primary.withValues(alpha: 0.12),
      borderRadius: AppRadius.lg,
      child: hasData ? _buildScore(theme) : _buildEmpty(theme),
    );
  }

  Widget _buildScore(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Restaurant Pulse',
          style: theme.textTheme.titleLarge?.copyWith(color: AppColors.surface),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          'Overall restaurant health',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.surface.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceMd),
        Row(
          children: [
            const RestaurantPulseHeart(score: 84, size: 124),
            const SizedBox(width: AppSpacing.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spaceSm,
                      vertical: AppSpacing.spaceXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(
                          AppIcons.check_circle_rounded,
                          color: AppColors.success,
                          size: 18,
                        ),
                        SizedBox(width: AppSpacing.spaceXs),
                        Flexible(
                          child: Text(
                            'Excellent Health',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Text(
                    '↑ 4 points vs last week',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.splashAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceMd),
        const Wrap(
          spacing: AppSpacing.spaceXs,
          runSpacing: AppSpacing.spaceXs,
          children: [
            _HealthFactor(label: 'Sales', value: 'Strong'),
            _HealthFactor(label: 'Profitability', value: 'Healthy'),
          ],
        ),
      ],
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const AppIcon(
              AppIcons.monitor_heart_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceMd),
        Text(
          'Your Restaurant Pulse is waiting',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        Text(
          "Add your first sales and expense data to start understanding your restaurant's health.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceMd),
        FilledButton(
          onPressed: onAddOrder,
          child: const Text('Add First Order'),
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        TextButton(onPressed: onAddExpense, child: const Text('Add Expense')),
      ],
    );
  }
}

class _HealthFactor extends StatelessWidget {
  const _HealthFactor({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSm,
        vertical: AppSpacing.spaceXs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text.rich(
        TextSpan(
          text: '$label  ',
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
