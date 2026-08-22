import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_divider.dart';
import 'package:restropulse/src/core/widgets/app_card.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';

import 'order_channel_icon.dart';

class OrderChannelSelector extends StatelessWidget {
  const OrderChannelSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final OrderChannel selected;
  final ValueChanged<OrderChannel> onSelected;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<OrderChannel>(
      segments: const [
        ButtonSegment(
          value: OrderChannel.dineIn,
          label: Text('Dine-in'),
          icon: OrderChannelIcon(channel: OrderChannel.dineIn, size: 18),
        ),
        ButtonSegment(
          value: OrderChannel.takeaway,
          label: Text('Takeaway'),
          icon: OrderChannelIcon(channel: OrderChannel.takeaway, size: 18),
        ),
        ButtonSegment(
          value: OrderChannel.delivery,
          label: Text('Delivery'),
          icon: OrderChannelIcon(channel: OrderChannel.delivery, size: 18),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (selection) => onSelected(selection.first),
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpacing.spaceXs),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? Colors.white
              : Theme.of(context).colorScheme.onSurfaceVariant;
        }),
      ),
    );
  }
}

class OrderMenuBrowser extends StatelessWidget {
  const OrderMenuBrowser({
    required this.searchController,
    required this.selectedCategory,
    required this.items,
    required this.quantities,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onItemTap,
    super.key,
  });

  final TextEditingController searchController;
  final String selectedCategory;
  final List<MenuItemSnapshot> items;
  final Map<String, int> quantities;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<MenuItemSnapshot> onItemTap;

  static const categories = ['Popular', 'Momo', 'Burgers', 'Pizza', 'Drinks'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const ValueKey('menu-search-field'),
          controller: searchController,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search menu items',
            prefixIcon: SvgPicture.asset(
              AppIcons.search_rounded,
              width: 22,
              height: 22,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < categories.length; index++) ...[
                if (index > 0) const SizedBox(width: AppSpacing.spaceXs),
                ChoiceChip(
                  label: Text(categories[index]),
                  selected: selectedCategory == categories[index],
                  onSelected: (_) => onCategorySelected(categories[index]),
                  showCheckmark: false,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selectedCategory == categories[index]
                        ? Colors.white
                        : null,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.spaceLg),
            child: Text(
              'No active menu items found.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          for (final item in items) ...[
            _MenuItemCard(
              item: item,
              quantity: quantities[item.id] ?? 0,
              onTap: () => onItemTap(item),
            ),
            const SizedBox(height: AppSpacing.spaceXs),
          ],
      ],
    );
  }
}

class CurrentOrderItems extends StatelessWidget {
  const CurrentOrderItems({
    required this.items,
    required this.quantities,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    super.key,
  });

  final List<MenuItemSnapshot> items;
  final Map<String, int> quantities;
  final ValueChanged<MenuItemSnapshot> onIncrement;
  final ValueChanged<MenuItemSnapshot> onDecrement;
  final ValueChanged<MenuItemSnapshot> onRemove;

  @override
  Widget build(BuildContext context) {
    final selected = items.where((item) => (quantities[item.id] ?? 0) > 0);
    final theme = Theme.of(context);

    return AppCard(
      borderRadius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Current Order',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          if (selected.isEmpty)
            Text(
              'Tap a menu item to add it to this order.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            for (final item in selected) ...[
              _SelectedItemRow(
                item: item,
                quantity: quantities[item.id]!,
                onIncrement: () => onIncrement(item),
                onDecrement: () => onDecrement(item),
                onRemove: () => onRemove(item),
              ),
              if (item != selected.last)
                AppDivider(height: 1, color: theme.colorScheme.outlineVariant),
            ],
        ],
      ),
    );
  }
}

class OrderTotalsCard extends StatelessWidget {
  const OrderTotalsCard({
    required this.subtotal,
    required this.discount,
    required this.onAddDiscount,
    required this.onAddNote,
    super.key,
  });

  final int subtotal;
  final int discount;
  final VoidCallback onAddDiscount;
  final VoidCallback onAddNote;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final total = subtotal - discount;
    final theme = Theme.of(context);

    return AppCard(
      borderRadius: AppRadius.lg,
      child: Column(
        children: [
          _TotalRow(
            label: 'Subtotal',
            value: 'Rs ${currency.format(subtotal)}',
          ),
          const SizedBox(height: AppSpacing.spaceXs),
          _TotalRow(
            label: 'Discount',
            value: 'Rs ${currency.format(discount)}',
          ),
          AppDivider(color: theme.colorScheme.outlineVariant),
          _TotalRow(
            label: 'Total',
            value: 'Rs ${currency.format(total)}',
            isStrong: true,
          ),
          const SizedBox(height: AppSpacing.spaceSm),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: onAddDiscount,
                  icon: SvgPicture.asset(
                    AppIcons.sell_outlined,
                    width: 20,
                    height: 20,
                  ),
                  label: Text(discount > 0 ? 'Edit Discount' : 'Add Discount'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: onAddNote,
                  icon: SvgPicture.asset(
                    AppIcons.note_add_outlined,
                    width: 20,
                    height: 20,
                  ),
                  label: const Text('Add Note'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  const _MenuItemCard({
    required this.item,
    required this.quantity,
    required this.onTap,
  });

  final MenuItemSnapshot item;
  final int quantity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: quantity > 0
              ? AppColors.primary.withValues(alpha: .45)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceSm),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.splashAccent.withValues(alpha: .38),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: SvgPicture.asset(
                  AppIcons.restaurant_menu_rounded,
                  width: 24,
                  height: 24,
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
                      item.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Rs ${item.sellingPrice}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (quantity > 0)
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  child: Text('$quantity'),
                )
              else
                SvgPicture.asset(
                  AppIcons.add_circle_rounded,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedItemRow extends StatelessWidget {
  const _SelectedItemRow({
    required this.item,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final MenuItemSnapshot item;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = NumberFormat.decimalPattern();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceXs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Rs ${currency.format(item.sellingPrice * quantity)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton.outlined(
            tooltip: 'Decrease ${item.name}',
            onPressed: onDecrement,
            visualDensity: VisualDensity.compact,
            icon: SvgPicture.asset(
              AppIcons.remove_rounded,
              width: 18,
              height: 18,
            ),
          ),
          SizedBox(
            width: 34,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          IconButton.outlined(
            tooltip: 'Increase ${item.name}',
            onPressed: onIncrement,
            visualDensity: VisualDensity.compact,
            icon: SvgPicture.asset(AppIcons.add_rounded, width: 18, height: 18),
          ),
          IconButton(
            tooltip: 'Remove ${item.name}',
            onPressed: onRemove,
            icon: SvgPicture.asset(
              AppIcons.close_rounded,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.error,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.isStrong = false,
  });

  final String label;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    final style = isStrong
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          )
        : Theme.of(context).textTheme.bodyMedium;

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style?.copyWith(fontWeight: FontWeight.w800)),
      ],
    );
  }
}
