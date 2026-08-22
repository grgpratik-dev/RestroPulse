import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_card.dart';

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

    return AppCard(
      child: Column(
        children: [
          SvgPicture.asset(
            AppIcons.cloud_off_outlined,
            width: 42,
            height: 42,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.error,
              BlendMode.srcIn,
            ),
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
  const SalesOrdersEmptyState({required this.onRecordSales, super.key});

  final VoidCallback onRecordSales;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
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
            child: SvgPicture.asset(
              AppIcons.receipt_long_outlined,
              width: 32,
              height: 32,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
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
              onPressed: onRecordSales,
              icon: SvgPicture.asset(AppIcons.add_rounded),
              label: const Text('Record Sales'),
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
    return AppCard(
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
