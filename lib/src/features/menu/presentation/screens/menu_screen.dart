import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_add_floating_action_button.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/app_feature_header.dart';
import '../../../../core/widgets/app_period_selector.dart';
import '../../domain/models/menu_item.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/menu_performance_highlights.dart';
import '../widgets/menu_states.dart';

enum MenuViewState { loaded, empty, loading, error }

enum _ProfitabilityFilter {
  all('By Profitability'),
  profitable('Most Profitable'),
  bestSelling('Best Selling'),
  needsReview('Needs Review');

  const _ProfitabilityFilter(this.label);
  final String label;
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    this.viewState = MenuViewState.loaded,
    this.initialItems = MenuMockData.items,
    super.key,
  });

  final MenuViewState viewState;
  final List<MenuItem> initialItems;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final List<MenuItem> _items = [...widget.initialItems];
  String _category = 'All';
  _ProfitabilityFilter _profitability = _ProfitabilityFilter.all;
  MenuAnalysisPeriod _period = MenuAnalysisPeriod.month;

  List<MenuItem> get _analysisItems => MenuMockData.forPeriod(_items, _period);

  List<String> get _categories {
    final values = _items.map((item) => item.category).toSet().toList()..sort();
    return ['All', ...values];
  }

  List<MenuItem> get _visibleItems {
    final items = _analysisItems.where((item) {
      if (_category != 'All' && item.category != _category) return false;
      if (_profitability == _ProfitabilityFilter.needsReview) {
        final status = MenuPerformanceClassifier.classify(
          item,
          demandMultiplier: _period.mockMultiplier,
        );
        return status == MenuPerformanceStatus.reviewCost ||
            status == MenuPerformanceStatus.lowPerformer;
      }
      return true;
    }).toList();

    switch (_profitability) {
      case _ProfitabilityFilter.profitable:
        items.sort((a, b) => b.marginPercentage.compareTo(a.marginPercentage));
      case _ProfitabilityFilter.bestSelling:
        items.sort((a, b) => b.unitsSold.compareTo(a.unitsSold));
      case _ProfitabilityFilter.all:
      case _ProfitabilityFilter.needsReview:
        items.sort((a, b) => b.revenue.compareTo(a.revenue));
    }
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
            _FilterBar(
              categories: _categories,
              selectedCategory: _category,
              profitability: _profitability,
              onReset: () => setState(() {
                _category = 'All';
                _profitability = _ProfitabilityFilter.all;
              }),
              onCategoryChanged: (value) => setState(() => _category = value),
              onProfitabilityChanged: (value) =>
                  setState(() => _profitability = value),
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
            Text(
              'ITEM BREAKDOWN',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
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

    final items = _visibleItems;
    if (items.isEmpty) return const MenuNoResultsState();
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
    setState(() => _items.removeWhere((entry) => entry.id == item.id));
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
        icon: Icons.delete_outline_rounded,
        isDestructive: true,
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() => _items.removeWhere((entry) => entry.id == item.id));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Menu item deleted')));
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.categories,
    required this.selectedCategory,
    required this.profitability,
    required this.onReset,
    required this.onCategoryChanged,
    required this.onProfitabilityChanged,
  });

  final List<String> categories;
  final String selectedCategory;
  final _ProfitabilityFilter profitability;
  final VoidCallback onReset;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<_ProfitabilityFilter> onProfitabilityChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilledButton.icon(
            onPressed: onReset,
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            icon: const Icon(Icons.tune_rounded, size: 17),
            label: const Text('All Items'),
          ),
          const SizedBox(width: AppSpacing.spaceXs),
          PopupMenuButton<String>(
            initialValue: selectedCategory,
            onSelected: onCategoryChanged,
            itemBuilder: (_) => categories
                .map(
                  (category) =>
                      PopupMenuItem(value: category, child: Text(category)),
                )
                .toList(),
            child: _OutlinedFilter(
              label: selectedCategory == 'All'
                  ? 'By Category'
                  : selectedCategory,
            ),
          ),
          const SizedBox(width: AppSpacing.spaceXs),
          PopupMenuButton<_ProfitabilityFilter>(
            initialValue: profitability,
            onSelected: onProfitabilityChanged,
            itemBuilder: (_) => _ProfitabilityFilter.values
                .map(
                  (filter) =>
                      PopupMenuItem(value: filter, child: Text(filter.label)),
                )
                .toList(),
            child: _OutlinedFilter(label: profitability.label),
          ),
        ],
      ),
    );
  }
}

class _OutlinedFilter extends StatelessWidget {
  const _OutlinedFilter({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }
}
