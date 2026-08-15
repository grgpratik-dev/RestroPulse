import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/custom_container.dart';
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
      icon: Icons.ssid_chart_rounded,
      child: hasExpenseData
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'Rs ${currency.format(report.profit)}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _ChangeLabel(
                      value: report.profitChange,
                      positiveIsGood: true,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${report.profitMargin.toStringAsFixed(1)}% profit margin',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                _InsightBox(
                  icon: Icons.lightbulb_outline_rounded,
                  title: report.profitChange < 0
                      ? 'Sales increased, but profit fell'
                      : 'Profit improved this period',
                  message: report.profitChange < 0
                      ? 'Revenue grew by ${report.revenueChange.toStringAsFixed(1)}%, while expenses increased by ${report.expenseChange.toStringAsFixed(1)}%. Expenses grew faster than sales.'
                      : 'Revenue growth outpaced expenses, improving your estimated profit.',
                ),
              ],
            )
          : const _MissingData(
              message: 'Add expense data to calculate profitability.',
            ),
    );
  }
}

class FoodCostReportCard extends StatelessWidget {
  const FoodCostReportCard({required this.report, super.key});

  final ReportSnapshot report;

  @override
  Widget build(BuildContext context) {
    final aboveTarget = report.foodCost > 30;
    final color = aboveTarget ? const Color(0xFFB45309) : AppColors.primary;
    return _ReportCard(
      title: 'Food Cost',
      icon: Icons.restaurant_outlined,
      trailing: Text(
        'Target < 30%',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${report.foodCost.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              _ChangeLabel(
                value: report.foodCostChange,
                positiveIsGood: false,
                isPoints: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (report.foodCost / 40).clamp(0, 1),
              minHeight: 10,
              color: color,
              backgroundColor: color.withValues(alpha: 0.12),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            aboveTarget
                ? 'Food cost exceeded your target in 2 of the last 4 weeks.'
                : 'Food cost stayed within your target this period.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseBreakdownCard extends StatelessWidget {
  const ExpenseBreakdownCard({required this.onViewExpenses, super.key});

  final VoidCallback onViewExpenses;

  static const _items = [
    ('Ingredients', 210000.0, 0.44),
    ('Salaries', 120000.0, 0.25),
    ('Rent', 55000.0, 0.12),
    ('Packaging', 32000.0, 0.07),
    ('Other', 61300.0, 0.12),
  ];

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return _ReportCard(
      title: 'Where Money Went',
      icon: Icons.account_balance_wallet_outlined,
      footer: _CardAction(label: 'View Expenses', onTap: onViewExpenses),
      child: Column(
        children: [
          for (var index = 0; index < _items.length; index++) ...[
            _ProgressRow(
              label: _items[index].$1,
              value: 'Rs ${currency.format(_items[index].$2)}',
              percentage: _items[index].$3,
              color: const Color(0xFF0F8A63),
            ),
            if (index != _items.length - 1)
              const SizedBox(height: AppSpacing.spaceSm),
          ],
        ],
      ),
    );
  }
}

class SalesChannelReportCard extends StatelessWidget {
  const SalesChannelReportCard({required this.onViewSales, super.key});

  final VoidCallback onViewSales;

  static const _channels = [
    ('Dine-in', 'Rs 463,000', 0.55, 8),
    ('Takeaway', 'Rs 210,600', 0.25, 3),
    ('Delivery', 'Rs 168,900', 0.20, 24),
  ];

  @override
  Widget build(BuildContext context) {
    return _ReportCard(
      title: 'Sales by Channel',
      icon: Icons.storefront_outlined,
      footer: _CardAction(label: 'View Sales', onTap: onViewSales),
      child: Column(
        children: [
          for (var index = 0; index < _channels.length; index++) ...[
            _ProgressRow(
              label: _channels[index].$1,
              value: '${_channels[index].$2}  ·  ↑ ${_channels[index].$4}%',
              percentage: _channels[index].$3,
              color: const Color(0xFF5C6BC0),
            ),
            if (index != _channels.length - 1)
              const SizedBox(height: AppSpacing.spaceSm),
          ],
          const SizedBox(height: AppSpacing.spaceMd),
          const _InsightBox(
            icon: Icons.trending_up_rounded,
            title: 'Delivery is growing fastest',
            message: 'Delivery sales increased 24% compared with last month.',
          ),
        ],
      ),
    );
  }
}

class MenuPerformanceReportCard extends StatelessWidget {
  const MenuPerformanceReportCard({required this.onViewMenu, super.key});

  final VoidCallback onViewMenu;

  @override
  Widget build(BuildContext context) {
    return _ReportCard(
      title: 'Menu Performance',
      icon: Icons.restaurant_menu_rounded,
      footer: _CardAction(label: 'View Menu Performance', onTap: onViewMenu),
      child: const Column(
        children: [
          _ValueRow(
            label: 'Top revenue item',
            value: 'Chicken Burger',
            detail: 'Rs 84,300',
          ),
          Divider(height: 24),
          _ValueRow(
            label: 'Best margin item',
            value: 'Lemonade',
            detail: '68% margin',
          ),
          Divider(height: 24),
          _ValueRow(
            label: 'Most sold item',
            value: 'Chicken Momo',
            detail: '482 sold',
          ),
          Divider(height: 24),
          _ValueRow(
            label: 'Needs review',
            value: 'Chicken Pizza',
            detail: 'High sales · Low margin',
            warning: true,
          ),
        ],
      ),
    );
  }
}

class WastageReportCard extends StatelessWidget {
  const WastageReportCard({required this.onViewWastage, super.key});

  final VoidCallback onViewWastage;

  @override
  Widget build(BuildContext context) {
    return _ReportCard(
      title: 'Wastage',
      icon: Icons.delete_sweep_outlined,
      footer: _CardAction(label: 'View Wastage', onTap: onViewWastage),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _LabelValue(
                  label: 'Total loss',
                  value: 'Rs 12,450',
                  valueColor: Theme.of(context).colorScheme.error,
                ),
              ),
              const _ChangeLabel(value: 14, positiveIsGood: false),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          const Row(
            children: [
              Expanded(
                child: _LabelValue(label: 'Top wasted item', value: 'Chicken'),
              ),
              Expanded(
                child: _LabelValue(
                  label: 'Most common reason',
                  value: 'Overproduction',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          const _InsightBox(
            icon: Icons.info_outline_rounded,
            title: 'Overproduction increased wastage',
            message: 'It accounted for 46% of wastage, mainly during weekdays.',
          ),
        ],
      ),
    );
  }
}

class OrderBehaviourCard extends StatelessWidget {
  const OrderBehaviourCard({required this.orderCount, super.key});

  final int orderCount;

  @override
  Widget build(BuildContext context) {
    return _ReportCard(
      title: 'Order Behaviour',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: _LabelValue(
                  label: 'Average order value',
                  value: 'Rs 677',
                  detail: '↑ 6.2%',
                ),
              ),
              Expanded(
                child: _LabelValue(
                  label: 'Orders this period',
                  value: NumberFormat.decimalPattern().format(orderCount),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          const Row(
            children: [
              Expanded(
                child: _LabelValue(label: 'Busiest day', value: 'Saturday'),
              ),
              Expanded(
                child: _LabelValue(label: 'Busiest time', value: '7 PM – 9 PM'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BusinessInsightsSection extends StatelessWidget {
  const BusinessInsightsSection({super.key});

  static const _insights = [
    (
      Icons.trending_down_rounded,
      'Revenue increased, but margin declined',
      'Expenses grew faster than sales this month.',
      'Check Expenses',
    ),
    (
      Icons.restaurant_menu_rounded,
      'Chicken Burger is popular but costly',
      'It generated strong revenue, but its food cost reached 48%.',
      'Review High-Cost Items',
    ),
    (
      Icons.delivery_dining_outlined,
      'Delivery is growing fastest',
      'Delivery sales increased 24% compared with last month.',
      'View Delivery Sales',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Insights',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        for (final insight in _insights) ...[
          CustomContainer(
            padding: const EdgeInsets.all(AppSpacing.spaceMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4F5EF),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(insight.$1, color: AppColors.primary, size: 22),
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
                      const SizedBox(height: 5),
                      Text(
                        'Consider: ${insight.$4}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
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

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
    this.footer,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 21),
              const SizedBox(width: AppSpacing.spaceXs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          child,
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.spaceSm),
            const Divider(),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });

  final String label;
  final String value;
  final double percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(label)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            SizedBox(
              width: 34,
              child: Text(
                '${(percentage * 100).round()}%',
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 7,
            color: color,
            backgroundColor: color.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.label,
    required this.value,
    required this.detail,
    this.warning = false,
  });

  final String label;
  final String value;
  final String detail;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.spaceSm),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                detail,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: warning
                      ? const Color(0xFFB45309)
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LabelValue extends StatelessWidget {
  const _LabelValue({
    required this.label,
    required this.value,
    this.detail,
    this.valueColor,
  });

  final String label;
  final String value;
  final String? detail;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (detail != null)
          Text(
            detail!,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _ChangeLabel extends StatelessWidget {
  const _ChangeLabel({
    required this.value,
    required this.positiveIsGood,
    this.isPoints = false,
  });

  final double value;
  final bool positiveIsGood;
  final bool isPoints;

  @override
  Widget build(BuildContext context) {
    final isUp = value >= 0;
    final isGood = isUp == positiveIsGood;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: (isGood ? AppColors.primary : const Color(0xFFB45309))
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${isUp ? '↑' : '↓'} ${value.abs().toStringAsFixed(1)}${isPoints ? ' pts' : '%'}',
        style: TextStyle(
          color: isGood ? AppColors.primary : const Color(0xFFB45309),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InsightBox extends StatelessWidget {
  const _InsightBox({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceSm),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FBF7),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.spaceXs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(fontSize: 12, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  const _CardAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(onPressed: onTap, child: Text(label)),
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
          const Icon(Icons.info_outline_rounded, color: Color(0xFFB45309)),
          const SizedBox(width: AppSpacing.spaceSm),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
