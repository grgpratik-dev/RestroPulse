import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/screens/order_entry_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({required this.order, super.key});

  final SalesOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.decimalPattern();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${order.orderNumber}'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: 'Edit order',
            onPressed: () => _editOrder(context),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceXs,
            AppSpacing.spaceMd,
            AppSpacing.spaceXl,
          ),
          children: [
            CustomContainer(
              color: AppColors.splashAccent.withValues(alpha: .26),
              borderColor: AppColors.primary.withValues(alpha: .12),
              borderRadius: AppRadius.lg,
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Date',
                    value: DateFormat('MMM d, yyyy').format(order.orderedAt),
                  ),
                  _InfoRow(
                    label: 'Time',
                    value: DateFormat.jm().format(order.orderedAt),
                  ),
                  _InfoRow(label: 'Channel', value: order.channel.label),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            CustomContainer(
              borderRadius: AppRadius.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Items',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  for (final item in order.items) ...[
                    _OrderItemRow(item: item),
                    if (item != order.items.last)
                      Divider(color: theme.colorScheme.outlineVariant),
                  ],
                  const Divider(height: AppSpacing.spaceLg),
                  _InfoRow(
                    label: 'Subtotal',
                    value: 'Rs ${currency.format(order.subtotal)}',
                  ),
                  _InfoRow(
                    label: 'Discount',
                    value: 'Rs ${currency.format(order.discount)}',
                  ),
                  _InfoRow(
                    label: 'Total',
                    value: 'Rs ${currency.format(order.total)}',
                    isStrong: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            CustomContainer(
              borderRadius: AppRadius.lg,
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Estimated Food Cost',
                    value: 'Rs ${currency.format(order.estimatedFoodCost)}',
                  ),
                  if (order.notes != null && order.notes!.isNotEmpty)
                    _InfoRow(label: 'Note', value: order.notes!),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            OutlinedButton.icon(
              onPressed: () => _confirmDelete(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
              ),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Delete Order'),
            ),
          ],
        ),
      ),
    );
  }

  void _editOrder(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => OrderEntryScreen(initialOrder: order),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.delete_outline_rounded,
            color: Theme.of(context).colorScheme.error,
          ),
          title: const Text('Delete this order?'),
          content: const Text(
            "This order and its items will be removed from today's sales data.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
                messenger.showSnackBar(
                  const SnackBar(content: Text('Order deleted')),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item});

  final SalesOrderItem item;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${item.quantity} × Rs ${currency.format(item.unitPrice)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rs ${currency.format(item.lineTotal)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = isStrong
        ? theme.textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          )
        : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: style?.copyWith(
                color: isStrong
                    ? AppColors.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.spaceMd),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: style?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
