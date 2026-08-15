import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';

class DashboardLoadingSkeleton extends StatelessWidget {
  const DashboardLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SkeletonCard(height: 246),
        const SizedBox(height: AppSpacing.spaceMd),
        const _SkeletonCard(height: 92),
        const SizedBox(height: AppSpacing.spaceMd),
        Row(
          children: [
            const Expanded(child: _SkeletonCard(height: 128)),
            const SizedBox(width: AppSpacing.spaceSm),
            const Expanded(child: _SkeletonCard(height: 128)),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        Row(
          children: [
            const Expanded(child: _SkeletonCard(height: 128)),
            const SizedBox(width: AppSpacing.spaceSm),
            const Expanded(child: _SkeletonCard(height: 128)),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceLg),
        const _SkeletonCard(height: 132),
      ],
    );
  }
}

class DashboardErrorCard extends StatelessWidget {
  const DashboardErrorCard({required this.onTryAgain, super.key});

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomContainer(
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_off_outlined,
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Text(
            "Couldn't load your dashboard",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            'Check your connection and try again.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          FilledButton(onPressed: onTryAgain, child: const Text('Try Again')),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SkeletonLine(widthFactor: 0.56),
            const SizedBox(height: AppSpacing.spaceSm),
            const _SkeletonLine(widthFactor: 0.82, height: 22),
            const Spacer(),
            const _SkeletonLine(widthFactor: 0.42),
          ],
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor, this.height = 12});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.kNeutral200,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}
