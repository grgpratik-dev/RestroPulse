import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/sales_trend_data.dart';

void main() {
  SalesTrendDataset dataset(SalesTrendPeriod period) {
    return SalesTrendAggregator.prepare(
      orders: SalesTrendMockOrders.values,
      period: period,
      now: SalesTrendMockOrders.currentDate,
    );
  }

  test('uses Sunday through Saturday daily buckets for one week', () {
    final result = dataset(SalesTrendPeriod.week);

    expect(result.points, hasLength(7));
    expect(result.points.map((point) => point.label), [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ]);
    expect(result.bestPoint.tooltipLabel, 'Sunday');
    expect(result.bestPoint.value, 31200);
    expect(result.points.skip(1).every((point) => point.value == 0), isTrue);
  });

  test('generates partial-month weekly buckets dynamically', () {
    final result = dataset(SalesTrendPeriod.month);

    expect(result.points, hasLength(3));
    expect(result.points.map((point) => point.label), ['W1', 'W2', 'W3']);
    expect(result.points.last.tooltipLabel, 'Aug 15–16');
    expect(result.bestPoint.tooltipLabel, 'Aug 8–14');
    expect(result.bestPoint.value, 186500);
  });

  test('uses three monthly buckets for the quarter', () {
    final quarter = dataset(SalesTrendPeriod.quarter);

    expect(quarter.points, hasLength(3));
    expect(quarter.points.map((point) => point.label), ['Jun', 'Jul', 'Aug']);
    expect(quarter.bestPoint.summaryLabel, 'July');
    expect(quarter.bestPoint.value, 742500);
  });
}
