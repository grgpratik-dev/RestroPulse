import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/menu_item.dart';
import '../widgets/menu_item_detail_widgets.dart';

class MenuItemDetailsScreen extends StatefulWidget {
  const MenuItemDetailsScreen({required this.item, super.key});

  final MenuItem item;

  @override
  State<MenuItemDetailsScreen> createState() => _MenuItemDetailsScreenState();
}

class _MenuItemDetailsScreenState extends State<MenuItemDetailsScreen> {
  MenuPerformancePeriod _period = MenuPerformancePeriod.month;
  late MenuItem _item = widget.item;
  bool get _isActive => _item.isActive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Item Details'),
        actions: [
          TextButton(onPressed: _editItem, child: const Text('Edit Item')),
          const SizedBox(width: AppSpacing.spaceXs),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceSm,
            AppSpacing.spaceMd,
            AppSpacing.space2xl,
          ),
          children: [
            _ItemHeader(item: _item, isActive: _isActive),
            const SizedBox(height: AppSpacing.spaceMd),
            MenuPricingCard(item: _item),
            const SizedBox(height: AppSpacing.spaceMd),
            MenuPerformanceCard(
              item: _item,
              period: _period,
              onPeriodChanged: (value) => setState(() => _period = value),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            MenuClassificationCard(item: _item),
            const SizedBox(height: AppSpacing.spaceLg),
            OutlinedButton.icon(
              onPressed: _confirmStatusChange,
              icon: Icon(
                _isActive
                    ? Icons.pause_circle_outline_rounded
                    : Icons.play_circle_outline_rounded,
              ),
              label: Text(_isActive ? 'Deactivate Item' : 'Reactivate Item'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmStatusChange() async {
    if (!_isActive) {
      setState(() => _item = _item.copyWith(isActive: true));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item reactivated')));
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.pause_circle_outline_rounded,
          color: AppColors.primary,
          size: 34,
        ),
        title: const Text('Deactivate this item?'),
        content: const Text(
          'It will no longer appear when recording new orders, but historical sales data will remain available.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() => _item = _item.copyWith(isActive: false));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item deactivated')));
    }
  }

  Future<void> _editItem() async {
    final updated = await context.pushNamed<MenuItem>(
      AppRoute.addMenuItem.name,
      extra: _item,
    );
    if (!mounted || updated == null) return;
    setState(() => _item = updated);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Menu item updated')));
  }
}

class _ItemHeader extends StatelessWidget {
  const _ItemHeader({required this.item, required this.isActive});

  final MenuItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: const Color(0xFFE4F5EF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(
            Icons.restaurant_menu_rounded,
            color: AppColors.primary,
            size: 36,
          ),
        ),
        const SizedBox(width: AppSpacing.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.category,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFDDF7EC)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: isActive
                        ? AppColors.primary
                        : const Color(0xFF475569),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
