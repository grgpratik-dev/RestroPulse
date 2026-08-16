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
  late MenuItem _item = widget.item;

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
            MenuItemHeader(item: _item),
            const SizedBox(height: AppSpacing.spaceMd),
            MenuPricingCard(item: _item),
            const SizedBox(height: AppSpacing.spaceMd),
            MenuPerformanceCard(item: _item),
            const SizedBox(height: AppSpacing.spaceMd),
            MenuClassificationCard(item: _item),
            const SizedBox(height: AppSpacing.spaceLg),
            OutlinedButton.icon(
              onPressed: _confirmDelete,
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Delete Menu Item'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.error,
          size: 34,
        ),
        title: const Text('Delete this menu item?'),
        content: const Text(
          'This removes the item from your current menu. Its historical sales will remain available in reports.',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete Item'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.pop(true);
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
