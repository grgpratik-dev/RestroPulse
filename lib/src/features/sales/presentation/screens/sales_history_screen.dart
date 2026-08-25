import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_period_selector.dart';
import '../../domain/models/sales_order.dart';
import '../widgets/order_channel_filter.dart';
import '../widgets/sales_channel_card.dart';
import '../widgets/sales_history_data.dart';
import '../widgets/sales_history_trend_card.dart';
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
  late final DateTime _anchorDate;
  SalesHistoryPeriod _selectedPeriod = SalesHistoryPeriod.month;
  DateTimeRange? _customRange;
  OrderChannel? _selectedChannel;

  DateTimeRange get _selectedRange {
    return _customRange ?? _selectedPeriod.rangeEndingOn(_anchorDate);
  }

  @override
  void initState() {
    super.initState();
    _anchorDate = widget.initialDate ?? SalesHistoryMockData.latestRecordedDate;
  }

  @override
  Widget build(BuildContext context) {
    final range = _selectedRange;
    final snapshot = SalesHistoryMockData.snapshot(
      range,
      grouping: _customRange == null ? _selectedPeriod.trendGrouping : null,
    );
    final visibleOrders =
        snapshot.orders
            .where(
              (order) =>
                  _selectedChannel == null || order.channel == _selectedChannel,
            )
            .toList()
          ..sort((a, b) => b.orderedAt.compareTo(a.orderedAt));
    final groupedOrders = _groupOrdersByDate(visibleOrders);
    final orderCountLabel = _selectedChannel == null
        ? '${snapshot.totalOrders} orders'
        : '${_filteredOrderCount(snapshot.totalOrders, _selectedChannel!)} results';

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
            AppPeriodSelector<SalesHistoryPeriod>(
              selected: _selectedPeriod,
              options: SalesHistoryPeriod.values,
              labelOf: (period) => period.label,
              descriptionOf: (_) => _formatRange(range),
              onChanged: (period) {
                setState(() {
                  _selectedPeriod = period;
                  _customRange = null;
                });
              },
              title: 'Sales history period',
              showDescription: false,
            ),
            const SizedBox(height: AppSpacing.space2xs),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.calendar_today_outlined,
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: AppSpacing.spaceXs),
                Expanded(
                  child: Text(
                    _formatRange(range),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  key: const ValueKey('sales-history-custom-range'),
                  onPressed: _pickCustomRange,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Custom'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            PeriodSalesSummaryCard(
              revenue: snapshot.totalSales,
              orders: snapshot.totalOrders,
              averageOrder: snapshot.averageOrder,
              change: snapshot.change,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            SalesHistoryTrendCard(
              points: snapshot.trend,
              grouping: snapshot.trendGrouping,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            SalesChannelCard(totalRevenue: snapshot.totalSales),
            const SizedBox(height: AppSpacing.spaceLg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Orders',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  orderCountLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            OrderChannelFilter(
              selectedChannel: _selectedChannel,
              onSelected: (channel) {
                setState(() => _selectedChannel = channel);
              },
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            if (groupedOrders.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spaceLg,
                ),
                child: Text(
                  'No orders found for this period and channel.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              for (final group in groupedOrders.entries) ...[
                Text(
                  DateFormat('MMM d').format(group.key),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                for (var index = 0; index < group.value.length; index++) ...[
                  SalesOrderCard(
                    order: group.value[index],
                    onTap: () => _openOrder(context, group.value[index]),
                  ),
                  if (index != group.value.length - 1)
                    const SizedBox(height: AppSpacing.spaceXs),
                ],
                const SizedBox(height: AppSpacing.spaceMd),
              ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickCustomRange() async {
    final selected = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedRange,
      firstDate: DateTime(2025, 1),
      lastDate: SalesHistoryMockData.latestRecordedDate,
    );
    if (!mounted || selected == null) return;
    setState(() => _customRange = selected);
  }

  Map<DateTime, List<SalesOrder>> _groupOrdersByDate(List<SalesOrder> orders) {
    final grouped = <DateTime, List<SalesOrder>>{};
    for (final order in orders) {
      final date = DateTime(
        order.orderedAt.year,
        order.orderedAt.month,
        order.orderedAt.day,
      );
      grouped.putIfAbsent(date, () => []).add(order);
    }
    return grouped;
  }

  int _filteredOrderCount(int totalOrders, OrderChannel channel) {
    final share = switch (channel) {
      OrderChannel.dineIn => .55,
      OrderChannel.takeaway => .25,
      OrderChannel.delivery => .20,
    };
    return (totalOrders * share).round();
  }

  String _formatRange(DateTimeRange range) {
    final start = range.start;
    final end = range.end;
    if (start.year == end.year) {
      return '${DateFormat('MMM d').format(start)} – '
          '${DateFormat('MMM d, y').format(end)}';
    }
    return '${DateFormat('MMM d, y').format(start)} – '
        '${DateFormat('MMM d, y').format(end)}';
  }

  void _openOrder(BuildContext context, SalesOrder order) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => OrderDetailsScreen(order: order)),
    );
  }
}
