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
  const WastageSummaryCard({
    required this.snapshot,
    required this.topReason,
    super.key,
  });

  final WastageSnapshot snapshot;
  final WastageReason topReason;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return AppCard(
      color: AppColors.warning,
      borderColor: AppColors.warning,
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimated Loss',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.68),
              fontWeight: FontWeight.w700,
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
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Entries',
                  value: '${snapshot.entries}',
                ),
              ),
              Expanded(
                flex: 2,
                child: _SummaryMetric(
                  label: 'Top Reason',
                  value: topReason.label,
                ),
              ),
            ],
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
      title: 'Where Loss Came From',
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

class RecentWastageSection extends StatelessWidget {
  const RecentWastageSection({
    required this.entries,
    required this.onTap,
    required this.onViewHistory,
    super.key,
  });

  final List<WastageEntry> entries;
  final ValueChanged<WastageEntry> onTap;
  final VoidCallback onViewHistory;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final recentEntries = entries.take(5).toList();
    return _Section(
      title: 'Recent Wastage',
      action: TextButton(
        onPressed: onViewHistory,
        child: const Text('View History >'),
      ),
      child: Column(
        children: [
          for (var index = 0; index < recentEntries.length; index++) ...[
            InkWell(
              onTap: () => onTap(recentEntries[index]),
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
                            recentEntries[index].itemName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            [
                              if (_quantityLabel(recentEntries[index]) != null)
                                _quantityLabel(recentEntries[index])!,
                              recentEntries[index].reason.label,
                              _dateLabel(recentEntries[index].date),
                            ].join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Rs ${currency.format(recentEntries[index].estimatedLoss)}',
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
            if (index != recentEntries.length - 1) const AppDivider(height: 20),
          ],
        ],
      ),
    );
  }

  String? _quantityLabel(WastageEntry entry) {
    if (entry.quantity == null || entry.unit == null) return null;
    final quantity = entry.quantity! % 1 == 0
        ? entry.quantity!.toStringAsFixed(0)
        : entry.quantity.toString();
    return '$quantity ${entry.unit!.label}';
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
  const _Section({required this.title, required this.child, this.action});
  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppSectionHeading(title: title, trailing: action),
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
