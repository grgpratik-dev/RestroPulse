import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';

import 'sales_order_card.dart';

class RecentOrdersSection extends StatelessWidget {
  const RecentOrdersSection({
    required this.orders,
    required this.onOrderTap,
    required this.onViewHistory,
    this.maxVisibleOrders = 5,
    super.key,
  });

  final List<SalesOrder> orders;
  final ValueChanged<SalesOrder> onOrderTap;
  final VoidCallback onViewHistory;
  final int maxVisibleOrders;

  @override
  Widget build(BuildContext context) {
    final recentOrders = orders.take(maxVisibleOrders).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent Orders',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: onViewHistory,
              child: const Text('View History →'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        for (var index = 0; index < recentOrders.length; index++) ...[
          SalesOrderCard(
            order: recentOrders[index],
            onTap: () => onOrderTap(recentOrders[index]),
          ),
          if (index != recentOrders.length - 1)
            const SizedBox(height: AppSpacing.spaceXs),
        ],
      ],
    );
  }
}
