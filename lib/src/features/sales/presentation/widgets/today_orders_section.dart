import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';

import 'sales_order_card.dart';

class TodayOrdersSection extends StatelessWidget {
  const TodayOrdersSection({
    required this.orders,
    required this.selectedChannel,
    required this.onChannelSelected,
    required this.onOrderTap,
    required this.onViewHistory,
    super.key,
  });

  final List<SalesOrder> orders;
  final OrderChannel? selectedChannel;
  final ValueChanged<OrderChannel?> onChannelSelected;
  final ValueChanged<SalesOrder> onOrderTap;
  final VoidCallback onViewHistory;

  @override
  Widget build(BuildContext context) {
    final visibleOrders = selectedChannel == null
        ? orders
        : orders.where((order) => order.channel == selectedChannel).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Today's Orders",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              '${orders.length} recent · 42 total',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'All',
                isSelected: selectedChannel == null,
                onTap: () => onChannelSelected(null),
              ),
              for (final channel in OrderChannel.values) ...[
                const SizedBox(width: AppSpacing.spaceXs),
                _FilterChip(
                  label: channel.label,
                  isSelected: selectedChannel == channel,
                  onTap: () => onChannelSelected(channel),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        if (visibleOrders.isEmpty)
          const _NoFilteredOrders()
        else
          Column(
            children: [
              for (var index = 0; index < visibleOrders.length; index++) ...[
                SalesOrderCard(
                  order: visibleOrders[index],
                  onTap: () => onOrderTap(visibleOrders[index]),
                ),
                if (index != visibleOrders.length - 1)
                  const SizedBox(height: AppSpacing.spaceXs),
              ],
            ],
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onViewHistory,
            child: const Text('View Sales History →'),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _NoFilteredOrders extends StatelessWidget {
  const _NoFilteredOrders();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      child: Text(
        'No orders match this channel.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
