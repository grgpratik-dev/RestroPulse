import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';

class SalesChannelCard extends StatelessWidget {
  const SalesChannelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomContainer(
      borderRadius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ChannelHeader(),
          SizedBox(height: AppSpacing.spaceMd),
          _ChannelRow(
            label: 'Dine-in',
            amount: 'Rs 15,650',
            percent: 55,
            color: AppColors.primary,
          ),
          SizedBox(height: AppSpacing.spaceMd),
          _ChannelRow(
            label: 'Takeaway',
            amount: 'Rs 7,100',
            percent: 25,
            color: Color(0xFF2563EB),
          ),
          SizedBox(height: AppSpacing.spaceMd),
          _ChannelRow(
            label: 'Delivery',
            amount: 'Rs 5,700',
            percent: 20,
            color: Color(0xFFB45309),
          ),
        ],
      ),
    );
  }
}

class SalesChannelEmptyCard extends StatelessWidget {
  const SalesChannelEmptyCard({required this.onUpdateSales, super.key});

  final VoidCallback onUpdateSales;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomContainer(
      child: Column(
        children: [
          const Icon(
            Icons.pie_chart_outline_rounded,
            color: AppColors.primary,
            size: 34,
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
