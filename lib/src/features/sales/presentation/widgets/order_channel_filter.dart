import 'package:flutter/material.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';

class OrderChannelFilter extends StatelessWidget {
  const OrderChannelFilter({
    required this.selectedChannel,
    required this.onSelected,
    super.key,
  });

  final OrderChannel? selectedChannel;
  final ValueChanged<OrderChannel?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ChannelChip(
            label: 'All',
            isSelected: selectedChannel == null,
            onTap: () => onSelected(null),
          ),
          for (final channel in OrderChannel.values) ...[
            const SizedBox(width: AppSpacing.spaceXs),
            _ChannelChip(
              label: channel.label,
              isSelected: selectedChannel == channel,
              onTap: () => onSelected(channel),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChannelChip extends StatelessWidget {
  const _ChannelChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
