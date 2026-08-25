import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../domain/models/wastage.dart';

class WastageHistorySummary extends StatelessWidget {
  const WastageHistorySummary({
    required this.rangeLabel,
    required this.totalLoss,
    required this.entries,
    required this.topReason,
    super.key,
  });

  final String rangeLabel;
  final double totalLoss;
  final int entries;
  final WastageReason? topReason;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    return AppCard(
      color: AppColors.warning,
      borderColor: AppColors.warning,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceMd,
        vertical: AppSpacing.spaceSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rangeLabel,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: .76),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            'Estimated Loss',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: .7),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Rs ${currency.format(totalLoss)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            [
              '$entries ${entries == 1 ? 'entry' : 'entries'}',
              if (topReason != null) 'Top reason: ${topReason!.label}',
            ].join(' · '),
            style: TextStyle(
              color: Colors.white.withValues(alpha: .82),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class WastageHistoryGroup extends StatelessWidget {
  const WastageHistoryGroup({
    required this.date,
    required this.entries,
    required this.onEntryTap,
    super.key,
  });

  final DateTime date;
  final List<WastageEntry> entries;
  final ValueChanged<WastageEntry> onEntryTap;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final total = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.estimatedLoss,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _dateLabel(date),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              'Rs ${currency.format(total)}',
              style: const TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceSm,
            vertical: AppSpacing.space2xs,
          ),
          child: Column(
            children: [
              for (var index = 0; index < entries.length; index++) ...[
                _WastageHistoryRow(
                  entry: entries[index],
                  onTap: () => onEntryTap(entries[index]),
                ),
                if (index != entries.length - 1) const AppDivider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _dateLabel(DateTime value) {
    if (value.year == 2026 && value.month == 8 && value.day == 16) {
      return 'Today · Aug 16';
    }
    return DateFormat('EEEE, MMM d').format(value);
  }
}

class WastageHistoryEmptyState extends StatelessWidget {
  const WastageHistoryEmptyState({required this.onChangeFilters, super.key});

  final VoidCallback onChangeFilters;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceXl),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.warningMuted,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: SvgPicture.asset(
                AppIcons.delete_sweep_outlined,
                width: 30,
                height: 30,
                colorFilter: const ColorFilter.mode(
                  AppColors.warning,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            Text(
              'No wastage found',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.space2xs),
            Text(
              'Try another period or clear your filters.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            OutlinedButton(
              onPressed: onChangeFilters,
              child: const Text('Change filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WastageHistoryRow extends StatelessWidget {
  const _WastageHistoryRow({required this.entry, required this.onTap});

  final WastageEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final quantity = _quantityLabel(entry);
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
                color: AppColors.warningMuted,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: SvgPicture.asset(
                AppIcons.delete_sweep_outlined,
                width: 21,
                height: 21,
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
                    entry.itemName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [?quantity, entry.reason.label].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.spaceXs),
            Text(
              'Rs ${currency.format(entry.estimatedLoss)}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            SvgPicture.asset(
              AppIcons.chevron_right_rounded,
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  String? _quantityLabel(WastageEntry value) {
    if (value.quantity == null || value.unit == null) return null;
    final amount = value.quantity! % 1 == 0
        ? value.quantity!.toStringAsFixed(0)
        : value.quantity.toString();
    return '$amount ${value.unit!.label}';
  }
}
