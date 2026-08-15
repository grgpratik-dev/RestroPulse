import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/menu_item.dart';

class MenuSummaryCard extends StatelessWidget {
  const MenuSummaryCard({required this.items, super.key});

  final List<MenuItem> items;

  @override
  Widget build(BuildContext context) {
    final active = items.where((item) => item.isActive).toList();
    final avgCost = active.isEmpty
        ? 0.0
        : active.fold<double>(0, (sum, item) => sum + item.foodCostPercentage) /
              active.length;
    final topSeller = items.isEmpty
        ? null
        : items.reduce((a, b) => a.unitsSold >= b.unitsSold ? a : b);

    return CustomContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceMd,
        vertical: AppSpacing.spaceSm,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _SummaryValue(
                label: 'Active items',
                value: '${active.length}',
              ),
            ),
            const VerticalDivider(indent: 4, endIndent: 4),
            Expanded(
              child: _SummaryValue(
                label: 'Avg. food cost',
                value: '${avgCost.toStringAsFixed(1)}%',
              ),
            ),
            const VerticalDivider(indent: 4, endIndent: 4),
            Expanded(
              flex: 2,
              child: _SummaryValue(
                label: 'Top seller',
                value: topSeller?.name ?? '—',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
