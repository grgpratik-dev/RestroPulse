import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/models/menu_item.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class MenuPerformanceHighlights extends StatelessWidget {
  const MenuPerformanceHighlights({required this.items, super.key});

  final List<MenuItem> items;

  @override
  Widget build(BuildContext context) {
    final soldItems = items.where((item) => item.unitsSold > 0).toList();
    if (soldItems.isEmpty) return const SizedBox.shrink();
    final bestSeller = soldItems.reduce(
      (a, b) => a.unitsSold >= b.unitsSold ? a : b,
    );
    final mostProfitable = soldItems.reduce(
      (a, b) => a.marginPercentage >= b.marginPercentage ? a : b,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _HighlightCard(
            eyebrow: 'BEST SELLER',
            icon: AppIcons.local_fire_department_outlined,
            itemName: bestSeller.name,
            value: '${bestSeller.unitsSold}',
            suffix: 'units sold',
            isPrimary: false,
          ),
        ),
        const SizedBox(width: AppSpacing.spaceSm),
        Expanded(
          child: _HighlightCard(
            eyebrow: 'MOST PROFITABLE',
            icon: AppIcons.trending_up_rounded,
            itemName: mostProfitable.name,
            value: '${mostProfitable.marginPercentage.toStringAsFixed(0)}%',
            suffix: 'margin',
            isPrimary: true,
          ),
        ),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.eyebrow,
    required this.icon,
    required this.itemName,
    required this.value,
    required this.suffix,
    required this.isPrimary,
  });

  final String eyebrow;
  final String icon;
  final String itemName;
  final String value;
  final String suffix;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final foreground = isPrimary ? Colors.white : AppColors.ink;
    final accent = isPrimary ? AppColors.mintBright : AppColors.primary;

    return Container(
      constraints: const BoxConstraints(minHeight: 138),
      padding: const EdgeInsets.all(AppSpacing.spaceSm),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primaryStrong : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isPrimary ? null : Border.all(color: AppColors.neutral200),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  eyebrow,
                  style: AppTypography.eyebrow.copyWith(color: accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            itemName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 6,
            children: [
              Text(
                value,
                style: AppTypography.metricSmall.copyWith(color: foreground),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  suffix,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isPrimary
                        ? Colors.white.withValues(alpha: 0.8)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
