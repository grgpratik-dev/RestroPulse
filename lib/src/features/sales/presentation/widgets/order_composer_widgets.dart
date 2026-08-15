import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/custom_container.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';

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
          icon: Icon(Icons.restaurant_outlined),
        ),
        ButtonSegment(
          value: OrderChannel.takeaway,
          label: Text('Takeaway'),
          icon: Icon(Icons.shopping_bag_outlined),
        ),
        ButtonSegment(
          value: OrderChannel.delivery,
          label: Text('Delivery'),
          icon: Icon(Icons.delivery_dining_outlined),
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
          decoration: const InputDecoration(
            hintText: 'Search menu items',
            prefixIcon: Icon(Icons.search_rounded),
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

    return CustomContainer(
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
                Divider(color: theme.colorScheme.outlineVariant),
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

    return CustomContainer(
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
          Divider(
            height: AppSpacing.spaceLg,
            color: theme.colorScheme.outlineVariant,
          ),
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
                  icon: const Icon(Icons.sell_outlined),
                  label: Text(discount > 0 ? 'Edit Discount' : 'Add Discount'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: onAddNote,
                  icon: const Icon(Icons.note_add_outlined),
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
                decoration: BoxDecoration(
                  color: AppColors.splashAccent.withValues(alpha: .38),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppColors.primary,
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
                const Icon(Icons.add_circle_rounded, color: AppColors.primary),
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
            icon: const Icon(Icons.remove_rounded),
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
            icon: const Icon(Icons.add_rounded),
          ),
          IconButton(
            tooltip: 'Remove ${item.name}',
            onPressed: onRemove,
            icon: Icon(Icons.close_rounded, color: theme.colorScheme.error),
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
