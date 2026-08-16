enum ReportPeriod {
  month('1M', 'Monthly Report', 'Compared with last month', 'August 2026'),
  quarter(
    '3M',
    'Three Month Report',
    'Compared with the previous 3 months',
    'June–August 2026',
  ),
  sixMonths(
    '6M',
    'Six Month Report',
    'Compared with the previous 6 months',
    'March–August 2026',
  ),
  year(
    '1Y',
    'Annual Report',
    'Compared with the previous year',
    'September 2025–August 2026',
  );

  const ReportPeriod(
    this.label,
    this.exportLabel,
    this.comparisonLabel,
    this.dateLabel,
  );

  final String label;
  final String exportLabel;
  final String comparisonLabel;
  final String dateLabel;
}

class ReportChartPoint {
  const ReportChartPoint(this.label, this.revenue, this.expenses);

  final String label;
  final double revenue;
  final double expenses;
}

class ReportSnapshot {
  const ReportSnapshot({
    required this.period,
    required this.revenue,
    required this.expenses,
    required this.revenueChange,
    required this.expenseChange,
    required this.profitChange,
    required this.marginChange,
    required this.foodCost,
    required this.foodCostChange,
    required this.chartPoints,
    required this.orders,
    required this.wastage,
    required this.wastageChange,
  });

  final ReportPeriod period;
  final double revenue;
  final double expenses;
  final double revenueChange;
  final double expenseChange;
  final double profitChange;
  final double marginChange;
  final double foodCost;
  final double foodCostChange;
  final List<ReportChartPoint> chartPoints;
  final int orders;
  final double wastage;
  final double wastageChange;

  double get estimatedFoodCost => revenue * foodCost / 100;
  double get grossProfit => revenue - estimatedFoodCost;
  double get profit => grossProfit - expenses;
  double get profitMargin => revenue == 0 ? 0 : profit / revenue * 100;
  double get averageOrderValue => orders == 0 ? 0 : revenue / orders;
}

abstract final class ReportsMockData {
  static ReportSnapshot forPeriod(ReportPeriod period) => switch (period) {
    ReportPeriod.month => const ReportSnapshot(
      period: ReportPeriod.month,
      revenue: 842500,
      expenses: 478300,
      revenueChange: 12.4,
      expenseChange: 18.6,
      profitChange: -2.1,
      marginChange: -1.8,
      foodCost: 28.4,
      foodCostChange: -1.2,
      orders: 1244,
      wastage: 12450,
      wastageChange: 14,
      chartPoints: [
        ReportChartPoint('W1', 178, 96),
        ReportChartPoint('W2', 196, 108),
        ReportChartPoint('W3', 218, 128),
        ReportChartPoint('W4', 250, 146),
      ],
    ),
    ReportPeriod.quarter => const ReportSnapshot(
      period: ReportPeriod.quarter,
      revenue: 2482500,
      expenses: 1408300,
      revenueChange: 14.6,
      expenseChange: 12.8,
      profitChange: 5.1,
      marginChange: 0.4,
      foodCost: 27.9,
      foodCostChange: -0.5,
      orders: 3684,
      wastage: 34800,
      wastageChange: 9.2,
      chartPoints: [
        ReportChartPoint('Jun', 784, 438),
        ReportChartPoint('Jul', 856, 492),
        ReportChartPoint('Aug', 842.5, 478.3),
      ],
    ),
    ReportPeriod.sixMonths => const ReportSnapshot(
      period: ReportPeriod.sixMonths,
      revenue: 4772500,
      expenses: 2699300,
      revenueChange: 16.8,
      expenseChange: 13.2,
      profitChange: 9.4,
      marginChange: 1.1,
      foodCost: 27.6,
      foodCostChange: -0.9,
      orders: 7082,
      wastage: 68100,
      wastageChange: 4.8,
      chartPoints: [
        ReportChartPoint('Mar', 718, 399),
        ReportChartPoint('Apr', 742, 414),
        ReportChartPoint('May', 830, 468),
        ReportChartPoint('Jun', 784, 438),
        ReportChartPoint('Jul', 856, 502),
        ReportChartPoint('Aug', 842.5, 478.3),
      ],
    ),
    ReportPeriod.year => const ReportSnapshot(
      period: ReportPeriod.year,
      revenue: 8812500,
      expenses: 4958300,
      revenueChange: 21.4,
      expenseChange: 15.7,
      profitChange: 13.8,
      marginChange: 1.9,
      foodCost: 27.2,
      foodCostChange: -1.4,
      orders: 13140,
      wastage: 128400,
      wastageChange: -3.2,
      chartPoints: [
        ReportChartPoint('Sep', 618, 348),
        ReportChartPoint('Oct', 646, 361),
        ReportChartPoint('Nov', 675, 378),
        ReportChartPoint('Dec', 702, 392),
        ReportChartPoint('Jan', 724, 406),
        ReportChartPoint('Feb', 675, 392),
        ReportChartPoint('Mar', 718, 399),
        ReportChartPoint('Apr', 742, 414),
        ReportChartPoint('May', 830, 468),
        ReportChartPoint('Jun', 784, 438),
        ReportChartPoint('Jul', 856, 484),
        ReportChartPoint('Aug', 842.5, 478.3),
      ],
    ),
  };
}
