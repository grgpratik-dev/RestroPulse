import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/models/report_data.dart';

class ProfitabilityReportCard extends StatelessWidget {
  const ProfitabilityReportCard({
    required this.report,
    this.hasExpenseData = true,
    super.key,
  });

  final ReportSnapshot report;
  final bool hasExpenseData;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return _ReportCard(
      title: 'Estimated Profit',
      icon: AppIcons.ssid_chart_rounded,
      child: hasExpenseData
          ? Column(
              children: [
                _ProfitStep(
                  label: 'Revenue',
                  value: 'Rs ${currency.format(report.revenue)}',
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                _ProfitStep(
                  label: '− Estimated food cost',
                  value: 'Rs ${currency.format(report.estimatedFoodCost)}',
                ),
                const AppDivider(),
                _ProfitStep(
                  label: '= Gross profit',
                  value: 'Rs ${currency.format(report.grossProfit)}',
                  emphasized: true,
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                _ProfitStep(
                  label: '− Operating expenses',
                  value: 'Rs ${currency.format(report.expenses)}',
                ),
                const AppDivider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '= Estimated net profit',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Rs ${currency.format(report.profit)}',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Text(
                            '${report.profitMargin.toStringAsFixed(1)}% net margin',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    _ChangeLabel(
                      value: report.profitChange,
                      positiveIsGood: true,
                    ),
                  ],
                ),
              ],
            )
          : const _MissingData(
              message: 'Add expense data to calculate profitability.',
            ),
    );
  }
}

class OperationalHighlightsCard extends StatelessWidget {
  const OperationalHighlightsCard({
    required this.report,
    required this.onViewSales,
    required this.onViewMenu,
    required this.onViewWastage,
    super.key,
  });

  final ReportSnapshot report;
  final VoidCallback onViewSales;
  final VoidCallback onViewMenu;
  final VoidCallback onViewWastage;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final leadingChannel = _salesChannels(report).first;
    final menu = _menuPerformance(report.period);
    final wastage = _wastageData(report.period);
    final orders = _orderBehaviour(report.period);

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceMd),
      child: Column(
        children: [
          _OperationalHighlightRow(
            icon: AppIcons.restaurant_outlined,
            label: 'Food cost',
            value: '${report.foodCost.toStringAsFixed(1)}%',
            detail:
                '${report.foodCostChange >= 0 ? '↑' : '↓'} ${report.foodCostChange.abs().toStringAsFixed(1)} pts',
            detailIsGood: report.foodCostChange <= 0,
            onTap: onViewMenu,
          ),
          const AppDivider(height: 1),
          _OperationalHighlightRow(
            icon: AppIcons.salesChannel,
            label: 'Leading sales channel',
            value: leadingChannel.$1,
            detail: '${(leadingChannel.$3 * 100).round()}% of revenue',
            onTap: onViewSales,
          ),
          const AppDivider(height: 1),
          _OperationalHighlightRow(
            icon: AppIcons.restaurant_menu_rounded,
            label: 'Top revenue menu item',
            value: 'Chicken Burger',
            detail: menu.$1,
            onTap: onViewMenu,
          ),
          const AppDivider(height: 1),
          _OperationalHighlightRow(
            icon: AppIcons.delete_sweep_outlined,
            label: 'Wastage loss',
            value: wastage.$1,
            detail:
                '${wastage.$2 >= 0 ? '↑' : '↓'} ${wastage.$2.abs().toStringAsFixed(1)}%',
            detailIsGood: wastage.$2 <= 0,
            onTap: onViewWastage,
          ),
          const AppDivider(height: 1),
          _OperationalHighlightRow(
            icon: AppIcons.receipt_long_outlined,
            label: 'Average order value',
            value: 'Rs ${currency.format(report.averageOrderValue.round())}',
            detail: '↑ ${orders.$1.toStringAsFixed(1)}%',
            detailIsGood: true,
            onTap: onViewSales,
          ),
        ],
      ),
    );
  }
}

class _OperationalHighlightRow extends StatelessWidget {
  const _OperationalHighlightRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
    required this.onTap,
    this.detailIsGood,
  });

  final String icon;
  final String label;
  final String value;
  final String detail;
  final VoidCallback onTap;
  final bool? detailIsGood;

  @override
  Widget build(BuildContext context) {
    final detailColor = detailIsGood == null
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : detailIsGood!
        ? AppColors.primary
        : AppColors.warning;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceSm),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mintSoft,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.spaceSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
            Flexible(
              child: Text(
                detail,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: detailColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 3),
            SvgPicture.asset(
              AppIcons.chevron_right_rounded,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessInsightsSection extends StatelessWidget {
  const BusinessInsightsSection({
    required this.report,
    required this.onViewExpenses,
    required this.onViewMenu,
    required this.onViewSales,
    super.key,
  });

  final ReportSnapshot report;
  final VoidCallback onViewExpenses;
  final VoidCallback onViewMenu;
  final VoidCallback onViewSales;

  @override
  Widget build(BuildContext context) {
    final deliveryGrowth = _salesChannels(report).last.$4;
    final insights = [
      (
        AppIcons.trending_down_rounded,
        report.profitChange < 0
            ? 'Revenue increased, but profit declined'
            : 'Profit improved this period',
        report.profitChange < 0
            ? 'Expenses increased ${report.expenseChange.toStringAsFixed(1)}%, faster than revenue at ${report.revenueChange.toStringAsFixed(1)}%.'
            : 'Revenue growth outpaced expenses, improving estimated net profit.',
        'Check Expenses',
        onViewExpenses,
      ),
      (
        AppIcons.restaurant_menu_rounded,
        'Chicken Burger is popular but costly',
        'It generated strong revenue, but its food cost reached 48%.',
        'Review Menu Item',
        onViewMenu,
      ),
      (
        AppIcons.delivery_dining_outlined,
        'Delivery is growing fastest',
        'Delivery sales increased $deliveryGrowth% compared with the previous period.',
        'View Delivery Sales',
        onViewSales,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What Changed?',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        for (final insight in insights) ...[
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.spaceMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.mintSoft,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: SvgPicture.asset(
                    insight.$1,
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight.$2,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        insight.$3,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spaceXs),
                      TextButton(
                        onPressed: insight.$5,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(insight.$4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
        ],
      ],
    );
  }
}

class _ProfitStep extends StatelessWidget {
  const _ProfitStep({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: emphasized
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.spaceSm),
        Text(
          value,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: emphasized ? AppColors.primary : null,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

List<(String, double, double, int)> _salesChannels(ReportSnapshot report) {
  final growth = switch (report.period) {
    ReportPeriod.month => const [8, 3, 24],
    ReportPeriod.quarter => const [11, 7, 31],
    ReportPeriod.sixMonths => const [14, 9, 28],
    ReportPeriod.year => const [18, 12, 35],
  };
  return [
    ('Dine-in', report.revenue * .55, .55, growth[0]),
    ('Takeaway', report.revenue * .25, .25, growth[1]),
    ('Delivery', report.revenue * .20, .20, growth[2]),
  ];
}

(String, String) _menuPerformance(ReportPeriod period) => switch (period) {
  ReportPeriod.month => ('Rs 84,300', '482 sold'),
  ReportPeriod.quarter => ('Rs 246,800', '1,392 sold'),
  ReportPeriod.sixMonths => ('Rs 492,600', '2,804 sold'),
  ReportPeriod.year => ('Rs 968,400', '5,482 sold'),
};

(String, double, String, int) _wastageData(ReportPeriod period) =>
    switch (period) {
      ReportPeriod.month => ('Rs 12,450', 14, 'Overproduction', 46),
      ReportPeriod.quarter => ('Rs 34,800', 9.2, 'Expired', 38),
      ReportPeriod.sixMonths => ('Rs 68,100', 4.8, 'Overproduction', 42),
      ReportPeriod.year => ('Rs 128,400', -3.2, 'Overproduction', 40),
    };

(double, double, String, String) _orderBehaviour(ReportPeriod period) =>
    switch (period) {
      ReportPeriod.month => (6.2, 8.4, 'Saturday', '7 PM – 9 PM'),
      ReportPeriod.quarter => (5.6, 9.7, 'Friday', '6 PM – 9 PM'),
      ReportPeriod.sixMonths => (7.8, 11.2, 'Saturday', '6 PM – 9 PM'),
      ReportPeriod.year => (9.1, 14.6, 'Saturday', '6 PM – 9 PM'),
    };

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final String icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceXs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          child,
        ],
      ),
    );
  }
}

class _ChangeLabel extends StatelessWidget {
  const _ChangeLabel({required this.value, required this.positiveIsGood});

  final double value;
  final bool positiveIsGood;

  @override
  Widget build(BuildContext context) {
    final isUp = value >= 0;
    final isGood = isUp == positiveIsGood;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: (isGood ? AppColors.primary : AppColors.warning).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${isUp ? '↑' : '↓'} ${value.abs().toStringAsFixed(1)}%',
        style: TextStyle(
          color: isGood ? AppColors.primary : AppColors.warning,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MissingData extends StatelessWidget {
  const _MissingData({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceMd),
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.info_outline_rounded,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.warning,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
