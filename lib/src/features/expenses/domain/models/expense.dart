enum ExpenseType {
  variable('Variable'),
  fixed('Fixed');

  const ExpenseType(this.label);
  final String label;
}

enum ExpensePeriod {
  week('1W'),
  month('1M'),
  sixMonths('6M'),
  year('1Y');

  const ExpensePeriod(this.label);
  final String label;
}

enum ExpenseSort {
  newest('Newest'),
  oldest('Oldest'),
  highest('Highest Amount'),
  lowest('Lowest Amount');

  const ExpenseSort(this.label);
  final String label;
}

class Expense {
  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.type,
    this.notes,
    this.receiptPath,
  });

  final String id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final ExpenseType type;
  final String? notes;
  final String? receiptPath;

  Expense copyWith({
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    ExpenseType? type,
    String? notes,
    String? receiptPath,
  }) => Expense(
    id: id,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    description: description ?? this.description,
    date: date ?? this.date,
    type: type ?? this.type,
    notes: notes ?? this.notes,
    receiptPath: receiptPath ?? this.receiptPath,
  );
}

class ExpenseCategorySummary {
  const ExpenseCategorySummary({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.transactionCount,
    required this.change,
  });

  final String name;
  final double amount;
  final double percentage;
  final int transactionCount;
  final double change;
}

class ExpenseTrendPoint {
  const ExpenseTrendPoint(this.label, this.tooltipLabel, this.amount);

  final String label;
  final String tooltipLabel;
  final double amount;
}

class ExpensePeriodSnapshot {
  const ExpensePeriodSnapshot({
    required this.total,
    required this.change,
    required this.transactions,
    required this.averageDaily,
    required this.comparisonLabel,
    required this.trend,
  });

  final double total;
  final double change;
  final int transactions;
  final double averageDaily;
  final String comparisonLabel;
  final List<ExpenseTrendPoint> trend;
}

abstract final class ExpenseCategories {
  static const defaults = [
    'Ingredients',
    'Salaries',
    'Rent',
    'Utilities',
    'Packaging',
    'Gas',
    'Delivery Fees',
    'Marketing',
    'Repairs & Maintenance',
    'Equipment',
    'Miscellaneous',
  ];

  static ExpenseType suggestedType(String category) => switch (category) {
    'Salaries' || 'Rent' => ExpenseType.fixed,
    _ => ExpenseType.variable,
  };
}

abstract final class ExpensesMockData {
  static final expenses = <Expense>[
    Expense(
      id: 'expense-1',
      amount: 4500,
      category: 'Ingredients',
      description: 'Chicken supplier',
      date: DateTime(2026, 8, 16, 10, 42),
      type: ExpenseType.variable,
      notes: 'Weekly chicken purchase',
    ),
    Expense(
      id: 'expense-2',
      amount: 2200,
      category: 'Packaging',
      description: 'Takeaway containers',
      date: DateTime(2026, 8, 16, 9, 15),
      type: ExpenseType.variable,
    ),
    Expense(
      id: 'expense-3',
      amount: 8400,
      category: 'Utilities',
      description: 'Electricity',
      date: DateTime(2026, 8, 15),
      type: ExpenseType.variable,
    ),
    Expense(
      id: 'expense-4',
      amount: 3000,
      category: 'Marketing',
      description: 'Facebook promotion',
      date: DateTime(2026, 8, 14),
      type: ExpenseType.variable,
    ),
    Expense(
      id: 'expense-5',
      amount: 55000,
      category: 'Rent',
      description: 'Monthly restaurant rent',
      date: DateTime(2026, 8, 1),
      type: ExpenseType.fixed,
    ),
  ];

  static const categorySummaries = [
    ExpenseCategorySummary(
      name: 'Ingredients',
      amount: 210000,
      percentage: 0.44,
      transactionCount: 34,
      change: 14.2,
    ),
    ExpenseCategorySummary(
      name: 'Salaries',
      amount: 120000,
      percentage: 0.25,
      transactionCount: 12,
      change: 0,
    ),
    ExpenseCategorySummary(
      name: 'Rent',
      amount: 55000,
      percentage: 0.12,
      transactionCount: 1,
      change: 0,
    ),
    ExpenseCategorySummary(
      name: 'Packaging',
      amount: 32000,
      percentage: 0.07,
      transactionCount: 18,
      change: -8,
    ),
    ExpenseCategorySummary(
      name: 'Utilities',
      amount: 28300,
      percentage: 0.06,
      transactionCount: 8,
      change: 5.4,
    ),
    ExpenseCategorySummary(
      name: 'Other',
      amount: 33000,
      percentage: 0.06,
      transactionCount: 13,
      change: 2.1,
    ),
  ];

  static ExpensePeriodSnapshot snapshot(ExpensePeriod period) =>
      switch (period) {
        ExpensePeriod.week => const ExpensePeriodSnapshot(
          total: 112800,
          change: 6.4,
          transactions: 24,
          averageDaily: 16114,
          comparisonLabel: 'vs previous 7 days',
          trend: [
            ExpenseTrendPoint('Mon', 'Monday', 13.2),
            ExpenseTrendPoint('Tue', 'Tuesday', 14.8),
            ExpenseTrendPoint('Wed', 'Wednesday', 15.1),
            ExpenseTrendPoint('Thu', 'Thursday', 12.9),
            ExpenseTrendPoint('Fri', 'Friday', 16.3),
            ExpenseTrendPoint('Sat', 'Saturday', 24.5),
            ExpenseTrendPoint('Sun', 'Sunday', 16.0),
          ],
        ),
        ExpensePeriod.month => const ExpensePeriodSnapshot(
          total: 478300,
          change: 9.8,
          transactions: 86,
          averageDaily: 15429,
          comparisonLabel: 'vs previous month',
          trend: [
            ExpenseTrendPoint('W1', 'Aug 1–7', 98),
            ExpenseTrendPoint('W2', 'Aug 8–14', 124),
            ExpenseTrendPoint('W3', 'Aug 15–21', 106),
            ExpenseTrendPoint('W4', 'Aug 22–28', 88),
            ExpenseTrendPoint('W5', 'Aug 29–31', 62.3),
          ],
        ),
        ExpensePeriod.sixMonths => const ExpensePeriodSnapshot(
          total: 2576000,
          change: 7.3,
          transactions: 508,
          averageDaily: 14154,
          comparisonLabel: 'vs previous 6 months',
          trend: [
            ExpenseTrendPoint('Mar', 'March 2026', 382),
            ExpenseTrendPoint('Apr', 'April 2026', 401),
            ExpenseTrendPoint('May', 'May 2026', 416),
            ExpenseTrendPoint('Jun', 'June 2026', 438),
            ExpenseTrendPoint('Jul', 'July 2026', 492),
            ExpenseTrendPoint('Aug', 'August 2026', 447),
          ],
        ),
        ExpensePeriod.year => const ExpensePeriodSnapshot(
          total: 5168000,
          change: 12.1,
          transactions: 1012,
          averageDaily: 14159,
          comparisonLabel: 'vs previous 12 months',
          trend: [
            ExpenseTrendPoint('Sep', 'September 2025', 378),
            ExpenseTrendPoint('Oct', 'October 2025', 390),
            ExpenseTrendPoint('Nov', 'November 2025', 404),
            ExpenseTrendPoint('Dec', 'December 2025', 438),
            ExpenseTrendPoint('Jan', 'January 2026', 402),
            ExpenseTrendPoint('Feb', 'February 2026', 415),
            ExpenseTrendPoint('Mar', 'March 2026', 421),
            ExpenseTrendPoint('Apr', 'April 2026', 428),
            ExpenseTrendPoint('May', 'May 2026', 436),
            ExpenseTrendPoint('Jun', 'June 2026', 448),
            ExpenseTrendPoint('Jul', 'July 2026', 492),
            ExpenseTrendPoint('Aug', 'August 2026', 516),
          ],
        ),
      };
}
