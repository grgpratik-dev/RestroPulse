import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/menu_item.dart';
import 'menu_image_provider.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    required this.item,
    required this.onTap,
    required this.onAction,
    this.demandMultiplier = 1,
    super.key,
  });

  final MenuItem item;
  final VoidCallback onTap;
  final ValueChanged<String> onAction;
  final double demandMultiplier;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final status = MenuPerformanceClassifier.classify(
      item,
      demandMultiplier: demandMultiplier,
    );

    return Semantics(
      button: true,
      label: 'Open ${item.name} details',
      child: CustomContainer(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spaceSm),
            child: Row(
              children: [
                _MenuImage(path: item.imagePath),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 6),
                          _CompactStatus(status: status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _Metric(
                              label: 'PRICE',
                              value: 'Rs ${currency.format(item.sellingPrice)}',
                            ),
                          ),
                          Expanded(
                            child: _Metric(
                              label: 'FOOD COST',
                              value:
                                  '${item.foodCostPercentage.toStringAsFixed(0)}%',
                              positive: item.foodCostPercentage <= 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _Metric(
                              label: 'UNITS',
                              value: NumberFormat.decimalPattern().format(
                                item.unitsSold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _Metric(
                              label: 'REVENUE',
                              value: 'Rs ${currency.format(item.revenue)}',
                              positive: item.revenue > 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Item actions',
                  onSelected: onAction,
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'details',
                      child: Text('View details'),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit item'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete item',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuImage extends StatelessWidget {
  const _MenuImage({this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox.square(
        dimension: 64,
        child: path == null
            ? ColoredBox(
                color: AppColors.mintSoft,
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppColors.primary,
                  size: 30,
                ),
              )
            : Image(image: menuImageProvider(path!), fit: BoxFit.cover),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.positive = false,
  });

  final String label;
  final String value;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 9,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: positive ? AppColors.primary : null,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CompactStatus extends StatelessWidget {
  const _CompactStatus({required this.status});

  final MenuPerformanceStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, background, foreground) = switch (status) {
      MenuPerformanceStatus.star => (
        'HIGH DEMAND',
        AppColors.infoSurfaceSoft,
        AppColors.infoForeground,
      ),
      MenuPerformanceStatus.reviewCost => (
        'REVIEW COST',
        AppColors.warningChip,
        AppColors.warningStrong,
      ),
      MenuPerformanceStatus.promote => (
        'PROMOTE',
        AppColors.mintChip,
        AppColors.primary,
      ),
      MenuPerformanceStatus.lowPerformer => (
        'TRENDING DOWN',
        AppColors.dangerSurface,
        AppColors.danger,
      ),
      MenuPerformanceStatus.notEnoughData => (
        'NEW',
        AppColors.neutral300,
        AppColors.neutral700,
      ),
    };

    return Container(
      constraints: const BoxConstraints(maxWidth: 84),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: foreground,
          fontSize: 9,
          height: 1.05,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
