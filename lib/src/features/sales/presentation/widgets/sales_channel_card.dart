import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_card.dart';

class SalesChannelCard extends StatelessWidget {
  const SalesChannelCard({required this.totalRevenue, super.key});

  final int totalRevenue;

  @override
  Widget build(BuildContext context) {
    final dineInRevenue = (totalRevenue * .55).round();
    final takeawayRevenue = (totalRevenue * .25).round();
    final deliveryRevenue = totalRevenue - dineInRevenue - takeawayRevenue;
    String amount(int value) => 'Rs ${_formatAmount(value)}';

    return AppCard(
      borderRadius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ChannelHeader(),
          const SizedBox(height: AppSpacing.spaceMd),
          _ChannelRow(
            label: 'Dine-in',
            amount: amount(dineInRevenue),
            percent: 55,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          _ChannelRow(
            label: 'Takeaway',
            amount: amount(takeawayRevenue),
            percent: 25,
            color: AppColors.info,
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          _ChannelRow(
            label: 'Delivery',
            amount: amount(deliveryRevenue),
            percent: 20,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  String _formatAmount(int value) {
    final digits = value.toString();
    return digits.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  }
}

class SalesChannelEmptyCard extends StatelessWidget {
  const SalesChannelEmptyCard({required this.onUpdateSales, super.key});

  final VoidCallback onUpdateSales;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        children: [
          SvgPicture.asset(
            AppIcons.pie_chart_outline_rounded,
            width: 34,
            height: 34,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Text(
            'Channel data not recorded',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            'Add a channel breakdown to understand where sales come from.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          TextButton(
            onPressed: onUpdateSales,
            child: const Text('Update Sales'),
          ),
        ],
      ),
    );
  }
}

class _ChannelHeader extends StatelessWidget {
  const _ChannelHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Sales by Channel',
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _ChannelRow extends StatelessWidget {
  const _ChannelRow({
    required this.label,
    required this.amount,
    required this.percent,
    required this.color,
  });

  final String label;
  final String amount;
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$label, $amount, $percent percent',
      child: ExcludeSemantics(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  amount,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceXs),
                SizedBox(
                  width: 34,
                  child: Text(
                    '$percent%',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 7,
                backgroundColor: color.withValues(alpha: .1),
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
