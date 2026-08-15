enum ReportPeriod {
  week('1W', 'Weekly Report'),
  month('1M', 'Monthly Report'),
  sixMonths('6M', 'Six Month Report'),
  year('1Y', 'Annual Report');

  const ReportPeriod(this.label, this.exportLabel);

  final String label;
  final String exportLabel;
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
    required this.profit,
    required this.profitMargin,
    required this.revenueChange,
    required this.expenseChange,
    required this.profitChange,
    required this.marginChange,
    required this.foodCost,
    required this.foodCostChange,
    required this.chartPoints,
    required this.orders,
  });

  final ReportPeriod period;
  final double revenue;
  final double expenses;
  final double profit;
  final double profitMargin;
  final double revenueChange;
  final double expenseChange;
  final double profitChange;
  final double marginChange;
  final double foodCost;
  final double foodCostChange;
  final List<ReportChartPoint> chartPoints;
  final int orders;
}

abstract final class ReportsMockData {
  static ReportSnapshot forPeriod(ReportPeriod period) => switch (period) {
    ReportPeriod.week => const ReportSnapshot(
      period: ReportPeriod.week,
      revenue: 198500,
      expenses: 112800,
      profit: 36100,
      profitMargin: 18.2,
      revenueChange: 8.6,
      expenseChange: 11.4,
      profitChange: -1.3,
      marginChange: -0.8,
      foodCost: 27.8,
      foodCostChange: -0.6,
      orders: 298,
      chartPoints: [
        ReportChartPoint('Sun', 22, 14),
        ReportChartPoint('Mon', 24, 15),
        ReportChartPoint('Tue', 26, 16),
        ReportChartPoint('Wed', 25, 15),
        ReportChartPoint('Thu', 29, 16),
        ReportChartPoint('Fri', 34, 18),
        ReportChartPoint('Sat', 39, 19),
      ],
    ),
    ReportPeriod.month => const ReportSnapshot(
      period: ReportPeriod.month,
      revenue: 842500,
      expenses: 478300,
      profit: 146200,
      profitMargin: 17.4,
      revenueChange: 12.4,
      expenseChange: 18.6,
      profitChange: -2.1,
      marginChange: -1.8,
      foodCost: 28.4,
      foodCostChange: -1.2,
      orders: 1244,
      chartPoints: [
        ReportChartPoint('W1', 178, 96),
        ReportChartPoint('W2', 196, 108),
        ReportChartPoint('W3', 218, 128),
        ReportChartPoint('W4', 250, 146),
      ],
    ),
    ReportPeriod.sixMonths => const ReportSnapshot(
      period: ReportPeriod.sixMonths,
      revenue: 4682000,
      expenses: 2576000,
      profit: 852400,
      profitMargin: 18.2,
      revenueChange: 16.8,
      expenseChange: 14.1,
      profitChange: 4.8,
      marginChange: 0.6,
      foodCost: 27.9,
      foodCostChange: -0.4,
      orders: 7168,
      chartPoints: [
        ReportChartPoint('Mar', 680, 382),
        ReportChartPoint('Apr', 712, 401),
        ReportChartPoint('May', 748, 416),
        ReportChartPoint('Jun', 804, 438),
        ReportChartPoint('Jul', 826, 457),
        ReportChartPoint('Aug', 912, 482),
      ],
    ),
    ReportPeriod.year => const ReportSnapshot(
      period: ReportPeriod.year,
      revenue: 9245000,
      expenses: 5168000,
      profit: 1698000,
      profitMargin: 18.4,
      revenueChange: 21.2,
      expenseChange: 17.5,
      profitChange: 8.7,
      marginChange: 1.1,
      foodCost: 28.1,
      foodCostChange: -0.9,
      orders: 14382,
      chartPoints: [
        ReportChartPoint('Sep', 654, 378),
        ReportChartPoint('Oct', 682, 390),
        ReportChartPoint('Nov', 714, 404),
        ReportChartPoint('Dec', 782, 438),
        ReportChartPoint('Jan', 698, 402),
        ReportChartPoint('Feb', 724, 415),
        ReportChartPoint('Mar', 741, 421),
        ReportChartPoint('Apr', 756, 428),
        ReportChartPoint('May', 778, 436),
        ReportChartPoint('Jun', 812, 448),
        ReportChartPoint('Jul', 846, 461),
        ReportChartPoint('Aug', 858, 507),
      ],
    ),
  };
}
