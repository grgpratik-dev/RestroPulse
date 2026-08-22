import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/app_add_floating_action_button.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/app_feature_header.dart';
import '../../../../core/widgets/app_period_selector.dart';
import '../../domain/models/menu_item.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/menu_performance_highlights.dart';
import '../widgets/menu_states.dart';

enum MenuViewState { loaded, empty, loading, error }

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    this.viewState = MenuViewState.loaded,
    this.initialItems,
    super.key,
  });

  final MenuViewState viewState;
  final List<MenuItem>? initialItems;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final List<MenuItem> _items = [
    ...(widget.initialItems ?? MenuMockData.items),
  ];
  String _category = 'All';
  MenuAnalysisPeriod _period = MenuAnalysisPeriod.month;

  List<MenuItem> get _analysisItems => MenuMockData.forPeriod(_items, _period);

  List<String> get _categories {
    final categories = _items.map((item) => item.category).toSet().toList()
      ..sort();
    return ['All', ...categories];
  }

  List<MenuItem> get _displayItems {
    final items =
        _analysisItems
            .where((item) => _category == 'All' || item.category == _category)
            .toList()
          ..sort((a, b) => b.revenue.compareTo(a.revenue));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppAddFloatingActionButton(
        onPressed: _openAddItem,
        tooltip: 'Add menu item',
        heroTag: 'menu-add-item-fab',
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceXs,
            AppSpacing.spaceMd,
            AppSpacing.space6xl,
          ),
          children: [
            const AppFeatureHeader(
              title: 'Menu Performance',
              subtitle: 'Track menu profitability and popularity.',
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            AppPeriodSelector<MenuAnalysisPeriod>(
              selected: _period,
              options: MenuAnalysisPeriod.values,
              labelOf: (period) => period.label,
              descriptionOf: (period) => period.dateLabel,
              title: 'Menu analysis period',
              onChanged: (period) => setState(() => _period = period),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            if (_analysisItems.any((item) => item.unitsSold > 0)) ...[
              IntrinsicHeight(
                child: MenuPerformanceHighlights(items: _analysisItems),
              ),
              const SizedBox(height: AppSpacing.spaceXl),
            ],
            Row(
              children: [
                Expanded(
                  child: Text(
                    'ITEM BREAKDOWN',
                    style: AppTypography.eyebrow.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceSm),
                _CategoryFilter(
                  categories: _categories,
                  selected: _category,
                  onChanged: (category) => setState(() => _category = category),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.viewState == MenuViewState.loading) {
      return const MenuLoadingSkeleton();
    }
    if (widget.viewState == MenuViewState.error) {
      return MenuErrorState(onRetry: () {});
    }
    if (widget.viewState == MenuViewState.empty || _items.isEmpty) {
      return MenuEmptyState(onAddItem: _openAddItem);
    }

    final items = _displayItems;
    return Column(
      children: [
        for (final item in items) ...[
          MenuItemCard(
            item: item,
            demandMultiplier: _period.mockMultiplier,
            onTap: () => _openDetails(item),
            onAction: (action) => _handleItemAction(item, action),
          ),
          const SizedBox(height: AppSpacing.spaceSm),
        ],
      ],
    );
  }

  Future<void> _openAddItem() async {
    final item = await context.pushNamed<MenuItem>(AppRoute.addMenuItem.name);
    if (!mounted || item == null) return;
    setState(() => _items.insert(0, item));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Menu item added')));
  }

  Future<void> _openDetails(MenuItem item) async {
    final deleted = await context.pushNamed<bool>(
      AppRoute.menuItemDetails.name,
      extra: MenuItemDetailsData(
        item: item,
        periodLabel: '${_period.label} · ${_period.dateLabel}',
        demandMultiplier: _period.mockMultiplier,
      ),
    );
    if (!mounted || deleted != true) return;
    setState(() {
      _items.removeWhere((entry) => entry.id == item.id);
      _normalizeCategorySelection();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Menu item deleted')));
  }

  Future<void> _handleItemAction(MenuItem item, String action) async {
    final sourceItem = _items.firstWhere((entry) => entry.id == item.id);
    if (action == 'details') {
      await _openDetails(item);
      return;
    }
    if (action == 'edit') {
      final updated = await context.pushNamed<MenuItem>(
        AppRoute.addMenuItem.name,
        extra: sourceItem,
      );
      if (!mounted || updated == null) return;
      setState(() {
        final index = _items.indexWhere((entry) => entry.id == item.id);
        if (index >= 0) _items[index] = updated;
        _normalizeCategorySelection();
      });
      return;
    }

    if (action != 'delete') return;

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
    if (!mounted || confirmed != true) return;
    setState(() {
      _items.removeWhere((entry) => entry.id == item.id);
      _normalizeCategorySelection();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Menu item deleted')));
  }

  void _normalizeCategorySelection() {
    if (_category != 'All' &&
        !_items.any((item) => item.category == _category)) {
      _category = 'All';
    }
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final label = selected == 'All' ? 'All Categories' : selected;

    return PopupMenuButton<String>(
      key: const ValueKey('menu-category-filter'),
      tooltip: 'Filter menu by category',
      initialValue: selected,
      position: PopupMenuPosition.under,
      onSelected: onChanged,
      itemBuilder: (_) => categories
          .map(
            (category) => PopupMenuItem(
              key: ValueKey('menu-category-$category'),
              value: category,
              child: Text(category == 'All' ? 'All Categories' : category),
            ),
          )
          .toList(),
      child: Container(
        height: 36,
        constraints: const BoxConstraints(maxWidth: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 6),
            SvgPicture.asset(
              AppIcons.keyboard_arrow_down_rounded,
              width: 18,
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}
