import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/app/theme/app_typography.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

enum MetricStatus { positive, negative, warning, neutral }

class DashboardMetricCard extends StatelessWidget {
  const DashboardMetricCard({
    required this.icon,
    required this.title,
    required this.value,
    this.comparison,
    this.subtitle,
    this.status = MetricStatus.neutral,
    super.key,
  });

  final String icon;
  final String title;
  final String value;
  final String? comparison;
  final String? subtitle;
  final MetricStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = switch (status) {
      MetricStatus.positive => AppColors.success,
      MetricStatus.negative => theme.colorScheme.error,
      MetricStatus.warning => AppColors.warning,
      MetricStatus.neutral => theme.colorScheme.onSurfaceVariant,
    };

    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: status == MetricStatus.warning
                      ? AppColors.warningSoft
                      : AppColors.splashAccent.withValues(alpha: 0.36),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: AppIcon(icon, color: statusColor, size: 17),
              ),
              const SizedBox(width: AppSpacing.spaceXs),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            value,
            style: value == 'Not enough data'
                ? theme.textTheme.titleSmall
                : AppTypography.metricSmall.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
          ),
          if (comparison != null || subtitle != null) ...[
            const SizedBox(height: AppSpacing.spaceXs),
            Text(
              comparison ?? subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
