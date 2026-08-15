import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';

class SalesLoadingSkeleton extends StatelessWidget {
  const SalesLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SkeletonCard(height: 188),
        SizedBox(height: AppSpacing.spaceMd),
        _SkeletonCard(height: 220),
        SizedBox(height: AppSpacing.spaceMd),
        _SkeletonCard(height: 230),
        SizedBox(height: AppSpacing.spaceMd),
        _SkeletonCard(height: 180),
      ],
    );
  }
}

class SalesErrorCard extends StatelessWidget {
  const SalesErrorCard({required this.onTryAgain, super.key});

  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomContainer(
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 42,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Text(
            "Couldn't load sales data",
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

class SalesOrdersEmptyState extends StatelessWidget {
  const SalesOrdersEmptyState({
    required this.onAddOrder,
    required this.onBatchEntry,
    super.key,
  });

  final VoidCallback onAddOrder;
  final VoidCallback onBatchEntry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomContainer(
      color: AppColors.splashAccent.withValues(alpha: .25),
      borderColor: AppColors.primary.withValues(alpha: .12),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Text(
            'No orders recorded today',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            "Record orders as they happen, or enter today's bills later using Batch Entry.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onAddOrder,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Order'),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onBatchEntry,
              icon: const Icon(Icons.playlist_add_rounded),
              label: const Text('Batch Entry'),
            ),
          ),
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
            const _SkeletonLine(widthFactor: .48),
            const SizedBox(height: AppSpacing.spaceSm),
            const _SkeletonLine(widthFactor: .76, height: 24),
            const Spacer(),
            const _SkeletonLine(widthFactor: .62),
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
