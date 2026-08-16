import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';

class AttentionInsightCard extends StatelessWidget {
  const AttentionInsightCard({
    required this.onAction,
    this.isHealthy = false,
    super.key,
  });

  final VoidCallback onAction;
  final bool isHealthy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isHealthy ? AppColors.success : AppColors.warning;
    final background = isHealthy
        ? AppColors.successSurface
        : AppColors.warningSoft;

    return CustomContainer(
      color: background,
      borderColor: color.withValues(alpha: 0.18),
      borderRadius: AppRadius.lg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isHealthy
                  ? Icons.check_circle_outline_rounded
                  : Icons.warning_amber_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHealthy
                      ? 'Everything looks healthy'
                      : 'Food cost is approaching your target',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.space2xs),
                Text(
                  isHealthy
                      ? 'No major issues need your attention today.'
                      : 'Food cost is currently 28.4%. Your target is below 30%.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                if (!isHealthy) ...[
                  const SizedBox(height: AppSpacing.spaceXs),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: color,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(48, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Review Costs →'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
