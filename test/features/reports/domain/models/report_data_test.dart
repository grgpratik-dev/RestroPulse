import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/features/reports/domain/models/report_data.dart';

void main() {
  test('reports own all long-term analysis periods', () {
    expect(ReportPeriod.values, [
      ReportPeriod.month,
      ReportPeriod.quarter,
      ReportPeriod.sixMonths,
      ReportPeriod.year,
    ]);
    expect(ReportPeriod.values.map((period) => period.label), [
      '1M',
      '3M',
      '6M',
      '1Y',
    ]);
  });

  test('three-month report compares with the previous quarter', () {
    final report = ReportsMockData.forPeriod(ReportPeriod.quarter);

    expect(
      report.period.comparisonLabel,
      'Compared with the previous 3 months',
    );
    expect(report.chartPoints.map((point) => point.label), [
      'Jun',
      'Jul',
      'Aug',
    ]);
    expect(
      report.chartPoints.fold<double>(
        0,
        (total, point) => total + point.revenue,
      ),
      closeTo(report.revenue / 1000, 0.001),
    );
    expect(
      report.chartPoints.fold<double>(
        0,
        (total, point) => total + point.expenses,
      ),
      closeTo(report.expenses / 1000, 0.001),
    );
  });

  test('annual chart aggregates twelve monthly points', () {
    final report = ReportsMockData.forPeriod(ReportPeriod.year);

    expect(report.chartPoints, hasLength(12));
    expect(report.chartPoints.first.label, 'Sep');
    expect(report.chartPoints.last.label, 'Aug');
    expect(
      report.chartPoints.fold<double>(0, (sum, point) => sum + point.revenue),
      closeTo(report.revenue / 1000, 0.001),
    );
    expect(
      report.chartPoints.fold<double>(0, (sum, point) => sum + point.expenses),
      closeTo(report.expenses / 1000, 0.001),
    );
  });

  test('profit report follows the displayed financial formula', () {
    final report = ReportsMockData.forPeriod(ReportPeriod.month);

    expect(
      report.grossProfit,
      closeTo(report.revenue - report.estimatedFoodCost, 0.001),
    );
    expect(report.profit, closeTo(report.grossProfit - report.expenses, 0.001));
    expect(
      report.profitMargin,
      closeTo(report.profit / report.revenue * 100, 0.001),
    );
  });
}
