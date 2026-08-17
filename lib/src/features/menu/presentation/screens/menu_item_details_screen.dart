import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../domain/models/menu_item.dart';
import '../widgets/menu_item_detail_widgets.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class MenuItemDetailsScreen extends StatefulWidget {
  const MenuItemDetailsScreen({
    required this.item,
    this.periodLabel = '1M · August 2026',
    this.demandMultiplier = 1,
    super.key,
  });

  final MenuItem item;
  final String periodLabel;
  final double demandMultiplier;

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
            MenuPerformanceCard(item: _item, periodLabel: widget.periodLabel),
            const SizedBox(height: AppSpacing.spaceMd),
            MenuClassificationCard(
              item: _item,
              demandMultiplier: widget.demandMultiplier,
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            OutlinedButton.icon(
              onPressed: _confirmDelete,
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              icon: const AppIcon(AppIcons.delete_outline_rounded),
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
      builder: (context) => const AppConfirmationDialog(
        title: 'Delete this menu item?',
        message:
            'This removes the item from your current menu. Its historical sales will remain available in reports.',
        confirmLabel: 'Delete Item',
        icon: AppIcons.delete_outline_rounded,
        isDestructive: true,
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
