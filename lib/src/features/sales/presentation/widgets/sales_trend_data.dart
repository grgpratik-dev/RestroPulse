import 'package:intl/intl.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';

enum SalesTrendPeriod {
  week('1W'),
  month('1M'),
  sixMonths('6M'),
  year('1Y');

  const SalesTrendPeriod(this.label);

  final String label;
}

class SalesTrendPoint {
  const SalesTrendPoint({
    required this.label,
    required this.tooltipLabel,
    required this.value,
    this.summaryLabel,
  });

  final String label;
  final String tooltipLabel;
  final double value;
  final String? summaryLabel;
}

class SalesTrendDataset {
  const SalesTrendDataset({required this.points, required this.summaryTitle});

  final List<SalesTrendPoint> points;
  final String summaryTitle;

  SalesTrendPoint get bestPoint {
    return points.reduce(
      (best, point) => point.value > best.value ? point : best,
    );
  }
}

abstract final class SalesTrendAggregator {
  static SalesTrendDataset prepare({
    required List<SalesOrder> orders,
    required SalesTrendPeriod period,
    required DateTime now,
  }) {
    return switch (period) {
      SalesTrendPeriod.week => _week(orders, now),
      SalesTrendPeriod.month => _month(orders, now),
      SalesTrendPeriod.sixMonths => _months(orders, now, 6),
      SalesTrendPeriod.year => _months(orders, now, 12),
    };
  }

  static SalesTrendDataset _week(List<SalesOrder> orders, DateTime now) {
    // Dart uses Monday = 1 and Sunday = 7. Modulo maps Sunday to zero so
    // the visible calendar week always runs from Sunday through Saturday.
    final start = _dateOnly(now).subtract(Duration(days: now.weekday % 7));
    final points = <SalesTrendPoint>[];

    for (var offset = 0; offset < 7; offset++) {
      final day = start.add(Duration(days: offset));
      points.add(
        SalesTrendPoint(
          label: DateFormat('EEE').format(day),
          tooltipLabel: DateFormat('EEEE').format(day),
          value: _revenueBetween(orders, day, day),
        ),
      );
    }

    return SalesTrendDataset(points: points, summaryTitle: 'Best day');
  }

  static SalesTrendDataset _month(List<SalesOrder> orders, DateTime now) {
    final points = <SalesTrendPoint>[];
    var weekStart = DateTime(now.year, now.month);
    var weekNumber = 1;

    while (!weekStart.isAfter(_dateOnly(now))) {
      final naturalEnd = weekStart.add(const Duration(days: 6));
      final weekEnd = naturalEnd.isAfter(_dateOnly(now))
          ? _dateOnly(now)
          : naturalEnd;
      points.add(
        SalesTrendPoint(
          label: 'W$weekNumber',
          tooltipLabel:
              '${DateFormat('MMM d').format(weekStart)}–${DateFormat('d').format(weekEnd)}',
          value: _revenueBetween(orders, weekStart, weekEnd),
        ),
      );
      weekNumber++;
      weekStart = weekStart.add(const Duration(days: 7));
    }

    return SalesTrendDataset(points: points, summaryTitle: 'Best week');
  }

  static SalesTrendDataset _months(
    List<SalesOrder> orders,
    DateTime now,
    int count,
  ) {
    final points = <SalesTrendPoint>[];

    for (var offset = count - 1; offset >= 0; offset--) {
      final monthStart = DateTime(now.year, now.month - offset);
      final naturalEnd = DateTime(monthStart.year, monthStart.month + 1, 0);
      final monthEnd = naturalEnd.isAfter(_dateOnly(now))
          ? _dateOnly(now)
          : naturalEnd;
      points.add(
        SalesTrendPoint(
          label: DateFormat('MMM').format(monthStart),
          tooltipLabel: DateFormat('MMMM yyyy').format(monthStart),
          summaryLabel: DateFormat('MMMM').format(monthStart),
          value: _revenueBetween(orders, monthStart, monthEnd),
        ),
      );
    }

    return SalesTrendDataset(points: points, summaryTitle: 'Best month');
  }

  static double _revenueBetween(
    List<SalesOrder> orders,
    DateTime start,
    DateTime end,
  ) {
    final inclusiveEnd = end.add(const Duration(days: 1));
    return orders
        .where((order) {
          return !order.orderedAt.isBefore(start) &&
              order.orderedAt.isBefore(inclusiveEnd);
        })
        .fold<double>(0, (total, order) => total + order.total);
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}

/// Generates realistic order-level mock data for the trend preview.
/// Production data can be passed to [SalesTrendAggregator.prepare] unchanged.
abstract final class SalesTrendMockOrders {
  static final DateTime currentDate = DateTime(2026, 8, 16);

  static final List<SalesOrder> values = _buildOrders();

  static List<SalesOrder> _buildOrders() {
    final orders = <SalesOrder>[];
    var day = DateTime(2025, 9);
    var sequence = 1;

    while (!day.isAfter(currentDate)) {
      final revenue = _dailyRevenue(day);
      orders.add(
        SalesOrder(
          id: 'trend-order-$sequence',
          restaurantId: 'restaurant-1',
          orderNumber: '#T${sequence.toString().padLeft(4, '0')}',
          orderedAt: DateTime(day.year, day.month, day.day, 12),
          channel: OrderChannel.dineIn,
          items: [
            SalesOrderItem(
              id: 'trend-item-$sequence',
              menuItemId: 'trend-mock-item',
              name: 'Recorded order revenue',
              quantity: 1,
              unitPrice: revenue,
              unitCost: 0,
            ),
          ],
        ),
      );
      sequence++;
      day = day.add(const Duration(days: 1));
    }

    return orders;
  }

  static int _dailyRevenue(DateTime day) {
    if (day.year == 2026 && day.month == 8) {
      const augustValues = {
        1: 21500,
        2: 22100,
        3: 21800,
        4: 22600,
        5: 23100,
        6: 23900,
        7: 24000,
        8: 30500,
        9: 32200,
        10: 21400,
        11: 24800,
        12: 22100,
        13: 28600,
        14: 26900,
        15: 31400,
        16: 31200,
      };
      return augustValues[day.day] ?? 0;
    }

    if (day.year == 2026 && day.month == 7) {
      return day.day == 31 ? 24000 : 23950;
    }

    const monthlyDailyRevenue = {
      1: 19400,
      2: 19800,
      3: 20200,
      4: 20700,
      5: 21300,
      6: 22000,
      9: 17600,
      10: 18100,
      11: 18500,
      12: 19000,
    };
    return monthlyDailyRevenue[day.month] ?? 18000;
  }
}
