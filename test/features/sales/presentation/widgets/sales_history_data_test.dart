import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_history_data.dart';

void main() {
  final anchor = DateTime(2026, 8, 16);

  test('uses daily points for one week', () {
    final snapshot = SalesHistoryMockData.snapshot(
      SalesHistoryPeriod.week.rangeEndingOn(anchor),
    );

    expect(snapshot.trendGrouping, SalesTrendGrouping.daily);
    expect(snapshot.trend, hasLength(7));
  });

  test(
    'uses daily points for one month and weekly points for three months',
    () {
      final month = SalesHistoryMockData.snapshot(
        SalesHistoryPeriod.month.rangeEndingOn(anchor),
        grouping: SalesHistoryPeriod.month.trendGrouping,
      );
      final quarter = SalesHistoryMockData.snapshot(
        SalesHistoryPeriod.quarter.rangeEndingOn(anchor),
        grouping: SalesHistoryPeriod.quarter.trendGrouping,
      );

      expect(month.trendGrouping, SalesTrendGrouping.daily);
      expect(quarter.trendGrouping, SalesTrendGrouping.weekly);
    },
  );

  test('uses monthly points for six month and yearly periods', () {
    final sixMonths = SalesHistoryMockData.snapshot(
      SalesHistoryPeriod.sixMonths.rangeEndingOn(anchor),
    );
    final year = SalesHistoryMockData.snapshot(
      SalesHistoryPeriod.year.rangeEndingOn(anchor),
    );

    expect(sixMonths.trendGrouping, SalesTrendGrouping.monthly);
    expect(sixMonths.trend, hasLength(6));
    expect(year.trendGrouping, SalesTrendGrouping.monthly);
    expect(year.trend, hasLength(12));
  });

  test('filters mock orders to a custom range', () {
    final snapshot = SalesHistoryMockData.snapshot(
      DateTimeRange(start: DateTime(2026, 8, 15), end: anchor),
    );

    expect(snapshot.orders, hasLength(5));
    expect(
      snapshot.orders.every(
        (order) => order.orderedAt.day == 15 || order.orderedAt.day == 16,
      ),
      isTrue,
    );
  });
}
