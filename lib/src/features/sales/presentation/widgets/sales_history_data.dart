import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';

enum SalesHistoryPeriod {
  week('1W'),
  month('1M'),
  quarter('3M'),
  sixMonths('6M'),
  year('1Y');

  const SalesHistoryPeriod(this.label);

  final String label;

  SalesTrendGrouping get trendGrouping => switch (this) {
    SalesHistoryPeriod.week ||
    SalesHistoryPeriod.month => SalesTrendGrouping.daily,
    SalesHistoryPeriod.quarter => SalesTrendGrouping.weekly,
    SalesHistoryPeriod.sixMonths ||
    SalesHistoryPeriod.year => SalesTrendGrouping.monthly,
  };

  DateTimeRange rangeEndingOn(DateTime endDate) {
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    final start = switch (this) {
      SalesHistoryPeriod.week => end.subtract(const Duration(days: 6)),
      SalesHistoryPeriod.month => DateTime(end.year, end.month),
      SalesHistoryPeriod.quarter => DateTime(end.year, end.month - 2),
      SalesHistoryPeriod.sixMonths => DateTime(end.year, end.month - 5),
      SalesHistoryPeriod.year => DateTime(end.year - 1, end.month + 1),
    };
    return DateTimeRange(start: start, end: end);
  }
}

enum SalesTrendGrouping { daily, weekly, monthly }

class SalesHistoryTrendPoint {
  const SalesHistoryTrendPoint({
    required this.label,
    required this.tooltipLabel,
    required this.value,
  });

  final String label;
  final String tooltipLabel;
  final double value;
}

class SalesHistorySnapshot {
  const SalesHistorySnapshot({
    required this.totalSales,
    required this.totalOrders,
    required this.averageOrder,
    required this.change,
    required this.trendGrouping,
    required this.trend,
    required this.orders,
  });

  final int totalSales;
  final int totalOrders;
  final int averageOrder;
  final double change;
  final SalesTrendGrouping trendGrouping;
  final List<SalesHistoryTrendPoint> trend;
  final List<SalesOrder> orders;
}

abstract final class SalesHistoryMockData {
  static final DateTime latestRecordedDate = DateTime(2026, 8, 16);

  static final List<SalesOrder> orders = [
    ...SalesMockData.todayOrders,
    _order(
      id: 39,
      date: DateTime(2026, 8, 15, 20, 52),
      channel: OrderChannel.delivery,
      total: 1250,
      itemCount: 4,
    ),
    _order(
      id: 38,
      date: DateTime(2026, 8, 15, 19, 34),
      channel: OrderChannel.dineIn,
      total: 860,
      itemCount: 3,
    ),
    _order(
      id: 37,
      date: DateTime(2026, 8, 13, 21, 8),
      channel: OrderChannel.takeaway,
      total: 720,
      itemCount: 2,
    ),
    _order(
      id: 36,
      date: DateTime(2026, 8, 10, 18, 46),
      channel: OrderChannel.dineIn,
      total: 1680,
      itemCount: 5,
    ),
    _order(
      id: 35,
      date: DateTime(2026, 8, 4, 20, 14),
      channel: OrderChannel.delivery,
      total: 940,
      itemCount: 3,
    ),
    _order(
      id: 34,
      date: DateTime(2026, 7, 29, 19, 22),
      channel: OrderChannel.takeaway,
      total: 610,
      itemCount: 2,
    ),
    _order(
      id: 33,
      date: DateTime(2026, 6, 18, 20, 5),
      channel: OrderChannel.dineIn,
      total: 2140,
      itemCount: 7,
    ),
  ];

  static SalesHistorySnapshot snapshot(
    DateTimeRange range, {
    SalesTrendGrouping? grouping,
  }) {
    final dailyValues = _dailyValues(range);
    final totalSales = dailyValues.fold<int>(
      0,
      (total, value) => total + value.revenue,
    );
    final totalOrders = dailyValues.fold<int>(
      0,
      (total, value) => total + value.orders,
    );
    final previousRange = _previousEquivalentRange(range);
    final previousSales = _dailyValues(
      previousRange,
    ).fold<int>(0, (total, value) => total + value.revenue);
    final change = previousSales == 0
        ? 0.0
        : ((totalSales - previousSales) / previousSales) * 100;
    final resolvedGrouping = grouping ?? groupingForRange(range);

    return SalesHistorySnapshot(
      totalSales: totalSales,
      totalOrders: totalOrders,
      averageOrder: totalOrders == 0 ? 0 : (totalSales / totalOrders).round(),
      change: change,
      trendGrouping: resolvedGrouping,
      trend: _groupTrend(dailyValues, resolvedGrouping),
      orders: orders
          .where((order) => _contains(range, order.orderedAt))
          .toList(),
    );
  }

  static List<_DailySalesValue> _dailyValues(DateTimeRange range) {
    final values = <_DailySalesValue>[];
    var day = _dateOnly(range.start);
    final end = _dateOnly(range.end);

    while (!day.isAfter(end)) {
      final revenue = _revenueFor(day);
      values.add(
        _DailySalesValue(
          date: day,
          revenue: revenue,
          orders: (revenue / 700).round(),
        ),
      );
      day = day.add(const Duration(days: 1));
    }
    return values;
  }

  static List<SalesHistoryTrendPoint> _groupTrend(
    List<_DailySalesValue> values,
    SalesTrendGrouping grouping,
  ) {
    return switch (grouping) {
      SalesTrendGrouping.daily =>
        values
            .map(
              (value) => SalesHistoryTrendPoint(
                label: values.length <= 7
                    ? DateFormat('EEE').format(value.date)
                    : DateFormat('d').format(value.date),
                tooltipLabel: DateFormat('MMM d').format(value.date),
                value: value.revenue.toDouble(),
              ),
            )
            .toList(),
      SalesTrendGrouping.weekly => _weeklyTrend(values),
      SalesTrendGrouping.monthly => _monthlyTrend(values),
    };
  }

  static List<SalesHistoryTrendPoint> _weeklyTrend(
    List<_DailySalesValue> values,
  ) {
    final points = <SalesHistoryTrendPoint>[];
    for (var index = 0; index < values.length; index += 7) {
      final endIndex = (index + 6).clamp(0, values.length - 1);
      final group = values.sublist(index, endIndex + 1);
      points.add(
        SalesHistoryTrendPoint(
          label: 'W${points.length + 1}',
          tooltipLabel:
              '${DateFormat('MMM d').format(group.first.date)}–'
              '${DateFormat('MMM d').format(group.last.date)}',
          value: group.fold<double>(0, (total, value) => total + value.revenue),
        ),
      );
    }
    return points;
  }

  static List<SalesHistoryTrendPoint> _monthlyTrend(
    List<_DailySalesValue> values,
  ) {
    final grouped = <DateTime, List<_DailySalesValue>>{};
    for (final value in values) {
      grouped
          .putIfAbsent(DateTime(value.date.year, value.date.month), () => [])
          .add(value);
    }
    return grouped.entries
        .map(
          (entry) => SalesHistoryTrendPoint(
            label: DateFormat('MMM').format(entry.key),
            tooltipLabel: DateFormat('MMMM yyyy').format(entry.key),
            value: entry.value.fold<double>(
              0,
              (total, value) => total + value.revenue,
            ),
          ),
        )
        .toList();
  }

  static SalesTrendGrouping groupingForRange(DateTimeRange range) {
    final days = range.duration.inDays + 1;
    if (days <= 31) return SalesTrendGrouping.daily;
    if (days <= 120) return SalesTrendGrouping.weekly;
    return SalesTrendGrouping.monthly;
  }

  static DateTimeRange _previousEquivalentRange(DateTimeRange range) {
    final days = range.duration.inDays + 1;
    final end = _dateOnly(range.start).subtract(const Duration(days: 1));
    return DateTimeRange(
      start: end.subtract(Duration(days: days - 1)),
      end: end,
    );
  }

  static int _revenueFor(DateTime day) {
    const monthlyBase = {
      1: 19400,
      2: 19800,
      3: 20200,
      4: 20700,
      5: 21300,
      6: 22000,
      7: 23600,
      8: 25200,
      9: 17600,
      10: 18100,
      11: 18500,
      12: 19000,
    };
    final base = monthlyBase[day.month] ?? 20000;
    final weekendLift = day.weekday >= DateTime.friday ? 4200 : 0;
    final dailyVariation = ((day.day * 137) % 3600) - 1400;
    return base + weekendLift + dailyVariation;
  }

  static bool _contains(DateTimeRange range, DateTime value) {
    final date = _dateOnly(value);
    return !date.isBefore(_dateOnly(range.start)) &&
        !date.isAfter(_dateOnly(range.end));
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static SalesOrder _order({
    required int id,
    required DateTime date,
    required OrderChannel channel,
    required int total,
    required int itemCount,
  }) {
    final unitPrice = (total / itemCount).ceil();
    return SalesOrder(
      id: 'order-$id',
      restaurantId: 'restaurant-1',
      orderNumber: '#${id.toString().padLeft(4, '0')}',
      orderedAt: date,
      channel: channel,
      items: [
        SalesOrderItem(
          id: 'oi-$id-1',
          menuItemId: 'history-mock-item',
          name: 'Recorded order items',
          quantity: itemCount,
          unitPrice: unitPrice,
          unitCost: 0,
        ),
      ],
      discount: unitPrice * itemCount - total,
    );
  }
}

class _DailySalesValue {
  const _DailySalesValue({
    required this.date,
    required this.revenue,
    required this.orders,
  });

  final DateTime date;
  final int revenue;
  final int orders;
}
