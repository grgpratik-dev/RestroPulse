import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/screens/order_details_screen.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_channel_card.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales History'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
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
            Text(
              'Sales grouped by day',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            CustomContainer(
              padding: EdgeInsets.zero,
              borderRadius: AppRadius.lg,
              child: Column(
                children: [
                  _HistoryDayRow(
                    date: 'Aug 16',
                    orders: 42,
                    revenue: 'Rs 28,450',
                    onTap: () => _openDay(context, 'Aug 16'),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  _HistoryDayRow(
                    date: 'Aug 15',
                    orders: 38,
                    revenue: 'Rs 25,600',
                    onTap: () => _openDay(context, 'Aug 15'),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  _HistoryDayRow(
                    date: 'Aug 14',
                    orders: 51,
                    revenue: 'Rs 31,200',
                    onTap: () => _openDay(context, 'Aug 14'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDay(BuildContext context, String date) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => SalesHistoryDayScreen(date: date),
      ),
    );
  }
}

class SalesHistoryDayScreen extends StatelessWidget {
  const SalesHistoryDayScreen({required this.date, super.key});

  final String date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(date)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.spaceMd),
          children: [
            const CustomContainer(
              color: Color(0xFFE9FAF3),
              borderRadius: AppRadius.lg,
              child: Row(
                children: [
                  Expanded(
                    child: _DayMetric(label: 'Revenue', value: 'Rs 28,450'),
                  ),
                  Expanded(
                    child: _DayMetric(label: 'Orders', value: '42'),
                  ),
                  Expanded(
                    child: _DayMetric(label: 'Avg. Order', value: 'Rs 677'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            const SalesChannelCard(),
            const SizedBox(height: AppSpacing.spaceLg),
            Text(
              'Orders',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            for (final order in SalesMockData.todayOrders)
              Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.spaceXs),
                child: ListTile(
                  onTap: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => OrderDetailsScreen(order: order),
                    ),
                  ),
                  title: Text('Order ${order.orderNumber}'),
                  subtitle: Text(
                    '${order.channel.label} · ${order.itemCount} items',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HistoryDayRow extends StatelessWidget {
  const _HistoryDayRow({
    required this.date,
    required this.orders,
    required this.revenue,
    required this.onTap,
  });

  final String date;
  final int orders;
  final String revenue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceMd,
        vertical: AppSpacing.spaceXs,
      ),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.splashAccent.withValues(alpha: .38),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Icon(
          Icons.calendar_today_outlined,
          color: AppColors.primary,
        ),
      ),
      title: Text(date, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text('$orders orders'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(revenue, style: const TextStyle(fontWeight: FontWeight.w800)),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _DayMetric extends StatelessWidget {
  const _DayMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: AppSpacing.space2xs),
        Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
