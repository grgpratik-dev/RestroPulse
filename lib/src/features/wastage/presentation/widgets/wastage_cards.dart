import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../../../core/widgets/app_section_heading.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/models/wastage.dart';

class WastageSummaryCard extends StatelessWidget {
  const WastageSummaryCard({required this.snapshot, super.key});

  final WastageSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final improving = snapshot.change < 0;
    return AppCard(
      color: AppColors.ink,
      borderColor: AppColors.ink,
      padding: const EdgeInsets.all(AppSpacing.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL WASTAGE',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.68),
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Rs ${currency.format(snapshot.total)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${snapshot.change >= 0 ? '↑' : '↓'} ${snapshot.change.abs().toStringAsFixed(0)}% ${snapshot.comparisonLabel}',
            style: TextStyle(
              color: improving ? AppColors.splashAccent : AppColors.expenseWarm,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Entries',
                  value: '${snapshot.entries}',
                ),
              ),
              const Expanded(
                child: _SummaryMetric(label: 'Top item', value: 'Chicken'),
              ),
              const Expanded(
                child: _SummaryMetric(
                  label: 'Main cause',
                  value: 'Overproduction',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Text(
            improving
                ? 'Wastage is improving compared with the previous period.'
                : 'Wastage is increasing. You recorded Rs 1,520 more loss than last month.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class WastageTrendCard extends StatelessWidget {
  const WastageTrendCard({
    required this.period,
    required this.points,
    super.key,
  });

  final WastagePeriod period;
  final List<WastageTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    final highest = points.reduce((a, b) => a.amount >= b.amount ? a : b);
    final currency = NumberFormat.decimalPattern();
    final label = switch (period) {
      WastagePeriod.week => 'Highest wastage day',
      WastagePeriod.month => 'Highest wastage week',
      WastagePeriod.quarter => 'Highest wastage month',
    };
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wastage Trend',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.spaceLg),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: highest.amount * 1.25,
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: highest.amount / 4,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    strokeWidth: 0.7,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= points.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            points.length <= 7 || index.isEven
                                ? points[index].label
                                : '',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.ink,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                          '${points[group.x].tooltipLabel}\nRs ${currency.format(points[group.x].amount * 1000)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                  ),
                ),
                barGroups: [
                  for (var index = 0; index < points.length; index++)
                    BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: points[index].amount,
                          width: points.length > 7 ? 10 : 18,
                          color: AppColors.warningChart,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            '$label\n${highest.tooltipLabel} · Rs ${currency.format(highest.amount * 1000)}',
            style: const TextStyle(fontWeight: FontWeight.w700, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class WastageReasonsSection extends StatelessWidget {
  const WastageReasonsSection({required this.reasons, super.key});

  final List<WastageReasonSummary> reasons;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return _Section(
      title: 'Why Wastage Happened',
      child: Column(
        children: [
          for (var index = 0; index < reasons.length; index++) ...[
            Row(
              children: [
                Expanded(child: Text(reasons[index].reason.label)),
                Text(
                  'Rs ${currency.format(reasons[index].amount)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 34,
                  child: Text(
                    '${(reasons[index].share * 100).round()}%',
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: reasons[index].share,
                minHeight: 7,
                color: AppColors.warningChart,
                backgroundColor: AppColors.warningMuted,
              ),
            ),
            if (index != reasons.length - 1)
              const SizedBox(height: AppSpacing.spaceMd),
          ],
        ],
      ),
    );
  }
}

class MostWastedItemsSection extends StatelessWidget {
  const MostWastedItemsSection({required this.items, super.key});

  final List<WastedItemSummary> items;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return _Section(
      title: 'Most Wasted Items',
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.warningMuted,
                  child: SvgPicture.asset(
                    index == 0
                        ? AppIcons.set_meal_outlined
                        : AppIcons.eco_outlined,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.warning,
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
                        items[index].name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text('${items[index].entries} entries'),
                    ],
                  ),
                ),
                Text(
                  'Rs ${currency.format(items[index].amount)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            if (index != items.length - 1) const AppDivider(),
          ],
        ],
      ),
    );
  }
}

class RecentWastageSection extends StatelessWidget {
  const RecentWastageSection({
    required this.entries,
    required this.onTap,
    super.key,
  });

  final List<WastageEntry> entries;
  final ValueChanged<WastageEntry> onTap;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return _Section(
      title: 'Recent Wastage',
      child: Column(
        children: [
          for (var index = 0; index < entries.length; index++) ...[
            InkWell(
              onTap: () => onTap(entries[index]),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.warningMuted,
                      child: SvgPicture.asset(
                        AppIcons.delete_sweep_outlined,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.warning,
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
                            entries[index].itemName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${entries[index].reason.label} · ${_dateLabel(entries[index].date)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (entries[index].quantityLabel != null)
                            Text(
                              entries[index].quantityLabel!,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                        ],
                      ),
                    ),
                    Text(
                      'Rs ${currency.format(entries[index].estimatedLoss)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SvgPicture.asset(
                      AppIcons.chevron_right_rounded,
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            if (index != entries.length - 1) const AppDivider(height: 20),
          ],
        ],
      ),
    );
  }

  String _dateLabel(DateTime date) {
    if (date.year == 2026 && date.month == 8 && date.day == 16) return 'Today';
    if (date.year == 2026 && date.month == 8 && date.day == 15) {
      return 'Yesterday';
    }
    return DateFormat('MMM d').format(date);
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppSectionHeading(title: title),
      const SizedBox(height: AppSpacing.spaceSm),
      AppCard(child: child),
    ],
  );
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
