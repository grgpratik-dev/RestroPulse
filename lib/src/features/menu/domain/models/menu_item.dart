import 'package:restropulse/gen/assets.gen.dart';

enum MenuPerformanceStatus {
  star,
  reviewCost,
  promote,
  lowPerformer,
  notEnoughData,
}

enum MenuAnalysisPeriod {
  month('1M', 'August 2026', 1),
  quarter('3M', 'June–August 2026', 2.95),
  sixMonths('6M', 'March–August 2026', 5.7),
  year('1Y', 'September 2025–August 2026', 10.5);

  const MenuAnalysisPeriod(this.label, this.dateLabel, this.mockMultiplier);

  final String label;
  final String dateLabel;
  final double mockMultiplier;
}

class MenuItemDetailsData {
  const MenuItemDetailsData({
    required this.item,
    required this.periodLabel,
    required this.demandMultiplier,
  });

  final MenuItem item;
  final String periodLabel;
  final double demandMultiplier;
}

extension MenuPerformanceStatusX on MenuPerformanceStatus {
  String get label => switch (this) {
    MenuPerformanceStatus.star => 'Star',
    MenuPerformanceStatus.reviewCost => 'Review Cost',
    MenuPerformanceStatus.promote => 'Promote',
    MenuPerformanceStatus.lowPerformer => 'Low Performer',
    MenuPerformanceStatus.notEnoughData => 'Not enough data',
  };

  String get title => switch (this) {
    MenuPerformanceStatus.star => 'Star item',
    MenuPerformanceStatus.reviewCost => 'Review cost',
    MenuPerformanceStatus.promote => 'Promote this item',
    MenuPerformanceStatus.lowPerformer => 'Low performer',
    MenuPerformanceStatus.notEnoughData => 'Not enough data',
  };

  String get description => switch (this) {
    MenuPerformanceStatus.star => 'High sales and strong margin.',
    MenuPerformanceStatus.reviewCost =>
      'Strong sales, but the margin needs attention.',
    MenuPerformanceStatus.promote => 'Healthy margin with room to grow sales.',
    MenuPerformanceStatus.lowPerformer =>
      'Both demand and margin are below average.',
    MenuPerformanceStatus.notEnoughData =>
      'No sales have been recorded for this item yet.',
  };

  String get recommendation => switch (this) {
    MenuPerformanceStatus.star =>
      'Consider featuring this item more prominently.',
    MenuPerformanceStatus.reviewCost =>
      'Review portion size, ingredient cost, or selling price.',
    MenuPerformanceStatus.promote =>
      'Consider promoting this item to increase demand.',
    MenuPerformanceStatus.lowPerformer =>
      'Consider adjusting the item or removing it from the active menu.',
    MenuPerformanceStatus.notEnoughData =>
      'Record a few orders before evaluating this item.',
  };
}

class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.sellingPrice,
    required this.estimatedCost,
    required this.unitsSold,
    required this.revenue,
    required this.historicalCost,
    required this.ordersContainingItem,
    this.notes,
    this.imagePath,
  });

  final String id;
  final String name;
  final String category;
  final double sellingPrice;
  final double estimatedCost;

  /// Aggregated from historical order-item snapshots, never current prices.
  final int unitsSold;
  final double revenue;
  final double historicalCost;
  final int ordersContainingItem;
  final String? notes;
  final String? imagePath;

  double get foodCostPercentage =>
      sellingPrice <= 0 ? 0 : estimatedCost / sellingPrice * 100;
  double get contributionPerUnit => sellingPrice - estimatedCost;
  double get marginPercentage =>
      sellingPrice <= 0 ? 0 : contributionPerUnit / sellingPrice * 100;
  double get estimatedHistoricalCost => historicalCost;
  double get estimatedHistoricalContribution => revenue - historicalCost;

  MenuItem copyWith({
    String? name,
    String? category,
    double? sellingPrice,
    double? estimatedCost,
    String? notes,
    String? imagePath,
    int? unitsSold,
    double? revenue,
    double? historicalCost,
    int? ordersContainingItem,
  }) {
    return MenuItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      unitsSold: unitsSold ?? this.unitsSold,
      revenue: revenue ?? this.revenue,
      historicalCost: historicalCost ?? this.historicalCost,
      ordersContainingItem: ordersContainingItem ?? this.ordersContainingItem,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

abstract final class MenuPerformanceClassifier {
  static MenuPerformanceStatus classify(
    MenuItem item, {
    double demandMultiplier = 1,
  }) {
    if (item.unitsSold == 0) return MenuPerformanceStatus.notEnoughData;

    final hasHighSales = item.unitsSold >= 50 * demandMultiplier;
    final hasHighMargin = item.foodCostPercentage <= 40;

    return switch ((hasHighSales, hasHighMargin)) {
      (true, true) => MenuPerformanceStatus.star,
      (true, false) => MenuPerformanceStatus.reviewCost,
      (false, true) => MenuPerformanceStatus.promote,
      (false, false) => MenuPerformanceStatus.lowPerformer,
    };
  }
}

abstract final class MenuMockData {
  static final items = <MenuItem>[
    MenuItem(
      id: 'chicken-momo',
      name: 'Chicken Momo',
      category: 'Momo',
      sellingPrice: 180,
      estimatedCost: 62,
      unitsSold: 126,
      revenue: 22680,
      historicalCost: 7812,
      ordersContainingItem: 94,
      notes: 'House special served with tomato achar.',
      imagePath: Assets.images.menuChickenMomo.path,
    ),
    MenuItem(
      id: 'chicken-burger',
      name: 'Chicken Burger',
      category: 'Burgers',
      sellingPrice: 350,
      estimatedCost: 168,
      unitsSold: 82,
      revenue: 28700,
      historicalCost: 13776,
      ordersContainingItem: 71,
      imagePath: Assets.images.menuChickenBurger.path,
    ),
    MenuItem(
      id: 'lemonade',
      name: 'Fresh Mint Lemonade',
      category: 'Drinks',
      sellingPrice: 150,
      estimatedCost: 30,
      unitsSold: 24,
      revenue: 3600,
      historicalCost: 720,
      ordersContainingItem: 22,
      imagePath: Assets.images.menuMintLemonade.path,
    ),
    MenuItem(
      id: 'veg-pizza',
      name: 'Garden Fresh Veg Pizza',
      category: 'Pizza',
      sellingPrice: 480,
      estimatedCost: 264,
      unitsSold: 18,
      revenue: 8640,
      historicalCost: 4752,
      ordersContainingItem: 17,
      imagePath: Assets.images.menuVegPizza.path,
    ),
    MenuItem(
      id: 'buff-momo',
      name: 'Buff Jhol Momo',
      category: 'Momo',
      sellingPrice: 210,
      estimatedCost: 76,
      unitsSold: 96,
      revenue: 20160,
      historicalCost: 7296,
      ordersContainingItem: 80,
      imagePath: Assets.images.menuBuffJholMomo.path,
    ),
    MenuItem(
      id: 'crispy-fries',
      name: 'Crispy Masala Fries',
      category: 'Snacks',
      sellingPrice: 190,
      estimatedCost: 68,
      unitsSold: 0,
      revenue: 0,
      historicalCost: 0,
      ordersContainingItem: 0,
      imagePath: Assets.images.menuMasalaFries.path,
    ),
  ];

  static List<MenuItem> forPeriod(
    List<MenuItem> source,
    MenuAnalysisPeriod period,
  ) {
    if (period == MenuAnalysisPeriod.month) return [...source];
    final multiplier = period.mockMultiplier;
    return source
        .map(
          (item) => item.copyWith(
            unitsSold: (item.unitsSold * multiplier).round(),
            revenue: item.revenue * multiplier,
            historicalCost: item.historicalCost * multiplier,
            ordersContainingItem: (item.ordersContainingItem * multiplier)
                .round(),
          ),
        )
        .toList();
  }
}
