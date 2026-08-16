import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/features/expenses/domain/models/expense.dart';
import 'package:restropulse/src/features/reports/domain/models/report_data.dart';
import 'package:restropulse/src/features/wastage/domain/models/wastage.dart';

void main() {
  test('reports expose the long-term analysis timeline', () {
    expect(ReportPeriod.values.map((period) => period.label), [
      '1M',
      '3M',
      '6M',
      '1Y',
    ]);
  });

  test('three-month snapshots contain June through August', () {
    expect(
      ExpensesMockData.snapshot(
        ExpensePeriod.quarter,
      ).trend.map((point) => point.label),
      ['Jun', 'Jul', 'Aug'],
    );
    expect(
      WastageMockData.snapshot(
        WastagePeriod.quarter,
      ).trend.map((point) => point.label),
      ['Jun', 'Jul', 'Aug'],
    );
  });
}
