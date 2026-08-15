import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';

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
          CustomContainer(
            padding: EdgeInsets.zero,
            borderRadius: AppRadius.lg,
            child: Column(
              children: [
                for (var index = 0; index < visibleOrders.length; index++) ...[
                  _OrderRow(
                    order: visibleOrders[index],
                    onTap: () => onOrderTap(visibleOrders[index]),
                  ),
                  if (index != visibleOrders.length - 1)
                    Divider(
                      indent: AppSpacing.spaceMd,
                      endIndent: AppSpacing.spaceMd,
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: .55),
                    ),
                ],
              ],
            ),
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

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order, required this.onTap});

  final SalesOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.decimalPattern();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceMd),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _channelColor(order.channel).withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  _channelIcon(order.channel),
                  color: _channelColor(order.channel),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Order ${order.orderNumber}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spaceXs),
                        Text(
                          DateFormat.jm().format(order.orderedAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space2xs),
                    Text(
                      '${order.channel.label} · ${order.itemCount} items',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Rs ${currency.format(order.total)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _channelColor(OrderChannel channel) => switch (channel) {
    OrderChannel.dineIn => AppColors.primary,
    OrderChannel.takeaway => const Color(0xFF2563EB),
    OrderChannel.delivery => const Color(0xFFB45309),
  };

  IconData _channelIcon(OrderChannel channel) => switch (channel) {
    OrderChannel.dineIn => Icons.restaurant_outlined,
    OrderChannel.takeaway => Icons.shopping_bag_outlined,
    OrderChannel.delivery => Icons.delivery_dining_outlined,
  };
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
