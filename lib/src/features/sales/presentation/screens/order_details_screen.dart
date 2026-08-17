import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_confirmation_dialog.dart';
import 'package:restropulse/src/core/widgets/app_divider.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/screens/order_entry_screen.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/order_detail_widgets.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

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
            icon: const AppIcon(AppIcons.edit_outlined),
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
                  OrderDetailInfoRow(
                    label: 'Date',
                    value: DateFormat('MMM d, yyyy').format(order.orderedAt),
                  ),
                  OrderDetailInfoRow(
                    label: 'Time',
                    value: DateFormat.jm().format(order.orderedAt),
                  ),
                  OrderDetailInfoRow(
                    label: 'Channel',
                    value: order.channel.label,
                  ),
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
                    OrderDetailItemRow(item: item),
                    if (item != order.items.last)
                      AppDivider(
                        height: 1,
                        color: theme.colorScheme.outlineVariant,
                      ),
                  ],
                  const AppDivider(),
                  OrderDetailInfoRow(
                    label: 'Subtotal',
                    value: 'Rs ${currency.format(order.subtotal)}',
                  ),
                  OrderDetailInfoRow(
                    label: 'Discount',
                    value: 'Rs ${currency.format(order.discount)}',
                  ),
                  OrderDetailInfoRow(
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
                  OrderDetailInfoRow(
                    label: 'Estimated Food Cost',
                    value: 'Rs ${currency.format(order.estimatedFoodCost)}',
                  ),
                  if (order.notes != null && order.notes!.isNotEmpty)
                    OrderDetailInfoRow(label: 'Note', value: order.notes!),
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
              icon: const AppIcon(AppIcons.delete_outline_rounded),
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

  Future<void> _confirmDelete(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => const AppConfirmationDialog(
        title: 'Delete this order?',
        message:
            "This order and its items will be removed from today's sales data.",
        confirmLabel: 'Delete',
        icon: AppIcons.delete_outline_rounded,
        isDestructive: true,
      ),
    );
    if (confirmed != true || !context.mounted) return;
    Navigator.of(context).pop();
    messenger.showSnackBar(const SnackBar(content: Text('Order deleted')));
  }
}
