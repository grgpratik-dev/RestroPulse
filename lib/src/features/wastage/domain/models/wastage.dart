enum WastagePeriod {
  week('1W'),
  month('1M'),
  quarter('3M');

  const WastagePeriod(this.label);
  final String label;
}

enum WastageReason {
  overproduction('Overproduction'),
  expired('Expired'),
  preparationMistake('Preparation Mistake'),
  customerReturn('Customer Return'),
  damaged('Damaged'),
  staffMeal('Staff Meal'),
  other('Other');

  const WastageReason(this.label);
  final String label;
}

enum WastageUnit {
  kg('kg'),
  grams('g'),
  pieces('pcs'),
  portions('portions'),
  litres('litres'),
  other('other');

  const WastageUnit(this.label);
  final String label;
}

class WastageEntry {
  const WastageEntry({
    required this.id,
    required this.itemName,
    required this.estimatedLoss,
    required this.reason,
    required this.date,
    this.quantity,
    this.unit,
    this.notes,
  });

  final String id;
  final String itemName;
  final double estimatedLoss;
  final WastageReason reason;
  final DateTime date;
  final double? quantity;
  final WastageUnit? unit;
  final String? notes;

  String? get quantityLabel => quantity == null
      ? null
      : '${quantity! % 1 == 0 ? quantity!.toStringAsFixed(0) : quantity} ${unit?.label ?? ''}'
            .trim();

  WastageEntry copyWith({
    String? itemName,
    double? estimatedLoss,
    WastageReason? reason,
    DateTime? date,
    double? quantity,
    WastageUnit? unit,
    String? notes,
  }) => WastageEntry(
    id: id,
    itemName: itemName ?? this.itemName,
    estimatedLoss: estimatedLoss ?? this.estimatedLoss,
    reason: reason ?? this.reason,
    date: date ?? this.date,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    notes: notes ?? this.notes,
  );
}

class WastageTrendPoint {
  const WastageTrendPoint(this.label, this.tooltipLabel, this.amount);
  final String label;
  final String tooltipLabel;
  final double amount;
}

class WastageReasonSummary {
  const WastageReasonSummary(this.reason, this.amount, this.share);
  final WastageReason reason;
  final double amount;
  final double share;
}

class WastedItemSummary {
  const WastedItemSummary(this.name, this.amount, this.entries);
  final String name;
  final double amount;
  final int entries;
}

class WastageSnapshot {
  const WastageSnapshot({
    required this.total,
    required this.change,
    required this.entries,
    required this.comparisonLabel,
    required this.trend,
  });
  final double total;
  final double change;
  final int entries;
  final String comparisonLabel;
  final List<WastageTrendPoint> trend;
}

abstract final class WastageMockData {
  static final entries = <WastageEntry>[
    WastageEntry(
      id: 'waste-1',
      itemName: 'Chicken',
      estimatedLoss: 1250,
      reason: WastageReason.overproduction,
      date: DateTime(2026, 8, 16, 20, 40),
      quantity: 2.5,
      unit: WastageUnit.kg,
      notes: 'Prepared too much chicken for dinner service.',
    ),
    WastageEntry(
      id: 'waste-2',
      itemName: 'Vegetables',
      estimatedLoss: 620,
      reason: WastageReason.expired,
      date: DateTime(2026, 8, 15),
    ),
    WastageEntry(
      id: 'waste-3',
      itemName: 'Bread',
      estimatedLoss: 450,
      reason: WastageReason.preparationMistake,
      date: DateTime(2026, 8, 14),
      quantity: 5,
      unit: WastageUnit.pieces,
    ),
  ];

  static const reasons = [
    WastageReasonSummary(WastageReason.overproduction, 5727, 0.46),
    WastageReasonSummary(WastageReason.expired, 2739, 0.22),
    WastageReasonSummary(WastageReason.preparationMistake, 1992, 0.16),
    WastageReasonSummary(WastageReason.customerReturn, 996, 0.08),
    WastageReasonSummary(WastageReason.damaged, 623, 0.05),
    WastageReasonSummary(WastageReason.other, 373, 0.03),
  ];

  static const topItems = [
    WastedItemSummary('Chicken', 4200, 8),
    WastedItemSummary('Vegetables', 2650, 6),
    WastedItemSummary('Bread', 1450, 4),
    WastedItemSummary('Rice', 980, 3),
  ];

  static WastageSnapshot snapshot(WastagePeriod period) => switch (period) {
    WastagePeriod.week => const WastageSnapshot(
      total: 3240,
      change: 8,
      entries: 8,
      comparisonLabel: 'vs previous 7 days',
      trend: [
        WastageTrendPoint('Sun', 'Sunday', 0.50),
        WastageTrendPoint('Mon', 'Monday', 0.32),
        WastageTrendPoint('Tue', 'Tuesday', 0.28),
        WastageTrendPoint('Wed', 'Wednesday', 0.41),
        WastageTrendPoint('Thu', 'Thursday', 0.36),
        WastageTrendPoint('Fri', 'Friday', 0.52),
        WastageTrendPoint('Sat', 'Saturday', 1.85),
      ],
    ),
    WastagePeriod.month => const WastageSnapshot(
      total: 12450,
      change: 14,
      entries: 26,
      comparisonLabel: 'vs previous month',
      trend: [
        WastageTrendPoint('W1', 'Aug 1–7', 2.1),
        WastageTrendPoint('W2', 'Aug 8–14', 4.2),
        WastageTrendPoint('W3', 'Aug 15–21', 2.8),
        WastageTrendPoint('W4', 'Aug 22–28', 2.3),
        WastageTrendPoint('W5', 'Aug 29–31', 1.05),
      ],
    ),
    WastagePeriod.quarter => const WastageSnapshot(
      total: 38750,
      change: 6.4,
      entries: 78,
      comparisonLabel: 'vs previous 3 months',
      trend: [
        WastageTrendPoint('Jun', 'June 2026', 11.5),
        WastageTrendPoint('Jul', 'July 2026', 14.8),
        WastageTrendPoint('Aug', 'August 2026', 12.45),
      ],
    ),
  };
}
