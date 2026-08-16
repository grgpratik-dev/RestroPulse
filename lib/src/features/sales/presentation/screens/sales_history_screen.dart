import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../domain/models/sales_order.dart';
import '../widgets/sales_channel_card.dart';
import '../widgets/sales_history_widgets.dart';
import '../widgets/sales_order_card.dart';
import 'order_details_screen.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({this.initialDate, super.key});

  final DateTime? initialDate;

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  static final DateTime _latestRecordedDate = DateTime(2026, 8, 16);

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? _latestRecordedDate;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshotFor(_selectedDate);
    final dateLabel = DateFormat('EEEE, MMM d').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales History'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            key: const ValueKey('sales-history-calendar'),
            tooltip: 'Choose date',
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          const SizedBox(width: AppSpacing.spaceXs),
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
          children: snapshot == null
              ? [_NoSalesForDate(dateLabel: dateLabel, onChooseDate: _pickDate)]
              : [
                  SelectedDateSummaryCard(
                    dateLabel: dateLabel,
                    revenue: snapshot.revenue,
                    orders: snapshot.orders,
                    averageOrder: snapshot.averageOrder,
                    change: snapshot.change,
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  const SalesChannelCard(),
                  const SizedBox(height: AppSpacing.spaceLg),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Orders',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                        '${SalesMockData.todayOrders.length} recent · '
                        '${snapshot.orders} total',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  for (
                    var index = 0;
                    index < SalesMockData.todayOrders.length;
                    index++
                  ) ...[
                    SalesOrderCard(
                      order: SalesMockData.todayOrders[index],
                      onTap: () =>
                          _openOrder(context, SalesMockData.todayOrders[index]),
                    ),
                    if (index != SalesMockData.todayOrders.length - 1)
                      const SizedBox(height: AppSpacing.spaceXs),
                  ],
                ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: _latestRecordedDate,
    );
    if (!mounted || selected == null) return;
    setState(() => _selectedDate = selected);
  }

  void _openOrder(BuildContext context, SalesOrder order) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => OrderDetailsScreen(order: order)),
    );
  }
}

class _NoSalesForDate extends StatelessWidget {
  const _NoSalesForDate({required this.dateLabel, required this.onChooseDate});

  final String dateLabel;
  final VoidCallback onChooseDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceLg,
        vertical: AppSpacing.space2xl,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.splashAccent.withValues(alpha: .42),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Icons.event_busy_outlined,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Text(
            dateLabel,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          Text(
            'No sales were recorded on this date.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          OutlinedButton.icon(
            onPressed: onChooseDate,
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Choose another date'),
          ),
        ],
      ),
    );
  }
}

_DailySalesSnapshot? _snapshotFor(DateTime date) {
  final key = DateTime(date.year, date.month, date.day);
  return _dailySalesSnapshots[key];
}

final Map<DateTime, _DailySalesSnapshot> _dailySalesSnapshots = {
  DateTime(2026, 8, 16): const _DailySalesSnapshot(28450, 42, 677, 12.4),
  DateTime(2026, 8, 15): const _DailySalesSnapshot(25600, 38, 674, -4.8),
  DateTime(2026, 8, 14): const _DailySalesSnapshot(31200, 51, 612, 8.6),
};

class _DailySalesSnapshot {
  const _DailySalesSnapshot(
    this.revenue,
    this.orders,
    this.averageOrder,
    this.change,
  );

  final int revenue;
  final int orders;
  final int averageOrder;
  final double change;
}
