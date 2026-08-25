import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_card.dart';

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

    if (!hasData) {
      return AppCard(
        borderColor: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: AppRadius.lg,
        child: _buildEmpty(theme),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryStrong,
            AppColors.primary,
            AppColors.neutral900,
          ],
          stops: [0, .68, 1],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.surface.withValues(alpha: .12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .24),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            const Positioned(
              top: -62,
              right: -42,
              child: _HeroGlow(size: 150, opacity: .09),
            ),
            const Positioned(
              bottom: -54,
              left: -30,
              child: _HeroGlow(size: 112, opacity: .05),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.spaceMd),
              child: _buildScore(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScore(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Restaurant Pulse',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          'Overall restaurant health',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.surface.withValues(alpha: .7),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                '84 / 100',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceSm,
                vertical: AppSpacing.spaceXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppIcons.check_circle_rounded,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      AppColors.success,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceXs),
                  const Text(
                    'Excellent Health',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          '↑ 4 points vs last week',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.splashAccent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceSm,
            vertical: AppSpacing.spaceXs,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Row(
            children: [
              Expanded(
                child: _HealthFactor(label: 'Sales', value: 'Strong'),
              ),
              SizedBox(width: AppSpacing.spaceMd),
              Expanded(
                child: _HealthFactor(label: 'Profitability', value: 'Healthy'),
              ),
            ],
          ),
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
            child: SvgPicture.asset(
              AppIcons.monitor_heart_outlined,
              width: 28,
              height: 28,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.surface.withValues(alpha: .68),
          ),
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.surface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _HeroGlow extends StatelessWidget {
  const _HeroGlow({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
