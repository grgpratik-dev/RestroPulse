import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/menu_item.dart';

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
            icon: Icons.local_fire_department_outlined,
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
            icon: Icons.trending_up_rounded,
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
  final IconData icon;
  final String itemName;
  final String value;
  final String suffix;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final foreground = isPrimary ? Colors.white : const Color(0xFF102037);
    final accent = isPrimary ? const Color(0xFF7DE2B8) : AppColors.primary;

    return Container(
      constraints: const BoxConstraints(minHeight: 158),
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFF047857) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isPrimary ? null : Border.all(color: const Color(0xFFE5E7EB)),
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
              Icon(icon, size: 16, color: accent),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  eyebrow,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            itemName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const Spacer(),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 6,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  suffix,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isPrimary
                        ? Colors.white.withValues(alpha: 0.8)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
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
