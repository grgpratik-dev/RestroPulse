import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:restropulse/src/core/icons/app_icons.dart';
import '../../domain/models/sales_order.dart';

String orderChannelIconAsset(OrderChannel channel) => switch (channel) {
  OrderChannel.dineIn => AppIcons.orderDineIn,
  OrderChannel.takeaway => AppIcons.orderTakeaway,
  OrderChannel.delivery => AppIcons.orderDelivery,
};

class OrderChannelIcon extends StatelessWidget {
  const OrderChannelIcon({
    required this.channel,
    this.size = 24,
    this.color,
    super.key,
  });

  final OrderChannel channel;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? IconTheme.of(context).color;
    return SvgPicture.asset(
      orderChannelIconAsset(channel),
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: resolvedColor == null
          ? null
          : ColorFilter.mode(resolvedColor, BlendMode.srcIn),
    );
  }
}
