import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';

class TodaySalesSummaryCard extends StatelessWidget {
  const TodaySalesSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomContainer(
      color: AppColors.splashAccent.withValues(alpha: .28),
      borderColor: AppColors.primary.withValues(alpha: .12),
      borderRadius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Today's Sales",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            'Rs 28,450',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.primary,
              fontSize: 31,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            '↑ 12.4% vs yesterday',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Container(
            padding: const EdgeInsets.all(AppSpacing.spaceSm),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: .84),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(label: 'Orders', value: '42'),
                  ),
                  VerticalDivider(width: AppSpacing.spaceLg),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Average Order',
                      value: 'Rs 677',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SalesQuickMetrics extends StatelessWidget {
  const SalesQuickMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _QuickMetric(
                  icon: Icons.payments_outlined,
                  label: 'Avg. Order',
                  value: 'Rs 677',
                ),
              ),
              SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: _QuickMetric(
                  icon: Icons.restaurant_outlined,
                  label: 'Dine-in',
                  value: '55%',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.spaceSm),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _QuickMetric(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Takeaway',
                  value: '25%',
                  accent: Color(0xFF2563EB),
                ),
              ),
              SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: _QuickMetric(
                  icon: Icons.delivery_dining_outlined,
                  label: 'Delivery',
                  value: '20%',
                  accent: Color(0xFFB45309),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _QuickMetric extends StatelessWidget {
  const _QuickMetric({
    required this.icon,
    required this.label,
    required this.value,
    this.accent = AppColors.primary,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomContainer(
      padding: const EdgeInsets.all(AppSpacing.spaceSm),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: accent, size: 19),
          ),
          const SizedBox(width: AppSpacing.spaceXs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
