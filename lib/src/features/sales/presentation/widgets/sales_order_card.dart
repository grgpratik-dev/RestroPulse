import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/sales_order.dart';
import 'order_channel_icon.dart';

class SalesOrderCard extends StatelessWidget {
  const SalesOrderCard({required this.order, required this.onTap, super.key});

  final SalesOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.decimalPattern();
    final channelColor = _channelColor(order.channel);
    final itemLabel =
        '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}';

    return Semantics(
      button: true,
      label:
          'Order ${order.orderNumber}, ${order.channel.label}, $itemLabel, '
          'Rs ${currency.format(order.total)}, '
          '${DateFormat.jm().format(order.orderedAt)}',
      child: Container(
        key: ValueKey('order-card-${order.id}'),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: .62),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .045),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spaceSm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(AppSpacing.space2xs),
                    decoration: BoxDecoration(
                      color: channelColor.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: OrderChannelIcon(
                      channel: order.channel,
                      color: channelColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ${order.orderNumber}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.spaceXs),
                        Wrap(
                          spacing: AppSpacing.spaceXs,
                          runSpacing: AppSpacing.space2xs,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _ChannelBadge(
                              label: order.channel.label,
                              color: channelColor,
                            ),
                            Text(
                              itemLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceXs),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs ${currency.format(order.total)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space2xs),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppIcons.schedule_rounded,
                            width: 14,
                            height: 14,
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.onSurfaceVariant,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.space2xs),
                          Text(
                            DateFormat.jm().format(order.orderedAt),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.space2xs),
                  SvgPicture.asset(
                    AppIcons.chevron_right_rounded,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.onSurfaceVariant,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _channelColor(OrderChannel channel) => switch (channel) {
    OrderChannel.dineIn => AppColors.primary,
    OrderChannel.takeaway => AppColors.info,
    OrderChannel.delivery => AppColors.warning,
  };
}

class _ChannelBadge extends StatelessWidget {
  const _ChannelBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
