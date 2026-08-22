import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/widgets/app_card.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/widgets/order_composer_widgets.dart';

class OrderEntryScreen extends StatefulWidget {
  const OrderEntryScreen({
    this.isBatchMode = false,
    this.initialOrder,
    super.key,
  });

  final bool isBatchMode;
  final SalesOrder? initialOrder;

  @override
  State<OrderEntryScreen> createState() => _OrderEntryScreenState();
}

class _OrderEntryScreenState extends State<OrderEntryScreen> {
  final _searchController = TextEditingController();
  final _quantities = <String, int>{};
  final _sessionOrders = <_BatchOrderSummary>[];
  OrderChannel _channel = OrderChannel.dineIn;
  String _category = 'Popular';
  String _searchQuery = '';
  String? _notes;
  int _discount = 0;
  int _orderSequence = 43;
  bool _isSaving = false;
  String? _editingSessionOrderNumber;

  bool get _isEditing => widget.initialOrder != null;

  List<MenuItemSnapshot> get _visibleMenuItems {
    return SalesMockData.menuItems.where((item) {
      final matchesCategory = _category == 'Popular'
          ? item.isPopular
          : item.category == _category;
      final matchesSearch = item.name.toLowerCase().contains(
        _searchQuery.trim().toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get _subtotal {
    return SalesMockData.menuItems.fold(0, (total, item) {
      return total + item.sellingPrice * (_quantities[item.id] ?? 0);
    });
  }

  int get _sessionTotal {
    return _sessionOrders.fold(0, (total, order) => total + order.total);
  }

  @override
  void initState() {
    super.initState();
    final order = widget.initialOrder;
    if (order == null) return;

    _channel = order.channel;
    _discount = order.discount;
    _notes = order.notes;
    for (final item in order.items) {
      _quantities[item.menuItemId] = item.quantity;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing
        ? 'Edit Order'
        : widget.isBatchMode
        ? 'Batch Entry'
        : 'New Order';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceXs,
            AppSpacing.spaceMd,
            AppSpacing.spaceXl,
          ),
          children: [
            if (widget.isBatchMode) ...[
              _BatchHeader(
                orderCount: _sessionOrders.length,
                total: _sessionTotal,
              ),
              const SizedBox(height: AppSpacing.spaceMd),
            ] else
              Text(
                _isEditing
                    ? widget.initialOrder!.orderNumber
                    : 'Order #${_orderSequence.toString().padLeft(4, '0')}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            if (!widget.isBatchMode) const SizedBox(height: AppSpacing.spaceMd),
            Text(
              'Order Channel',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            OrderChannelSelector(
              selected: _channel,
              onSelected: (channel) => setState(() => _channel = channel),
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            Text(
              'Add Menu Items',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            OrderMenuBrowser(
              searchController: _searchController,
              selectedCategory: _category,
              items: _visibleMenuItems,
              quantities: _quantities,
              onSearchChanged: (query) => setState(() => _searchQuery = query),
              onCategorySelected: (category) {
                setState(() => _category = category);
              },
              onItemTap: _increment,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            CurrentOrderItems(
              items: SalesMockData.menuItems,
              quantities: _quantities,
              onIncrement: _increment,
              onDecrement: _decrement,
              onRemove: _remove,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            OrderTotalsCard(
              subtotal: _subtotal,
              discount: _discount,
              onAddDiscount: _showDiscountSheet,
              onAddNote: _showNoteSheet,
            ),
            if (widget.isBatchMode && _sessionOrders.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.spaceMd),
              _SessionOrdersCard(
                orders: _sessionOrders,
                onOrderTap: _editSessionOrder,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceSm,
            AppSpacing.spaceMd,
            AppSpacing.spaceMd,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const ValueKey('save-order-button'),
                  onPressed: _isSaving ? null : _saveOrder,
                  child: _isSaving
                      ? const SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.4,
                          ),
                        )
                      : Text(
                          _isEditing
                              ? 'Update Order'
                              : widget.isBatchMode
                              ? 'Save & Add Next'
                              : 'Save Order',
                        ),
                ),
              ),
              if (widget.isBatchMode) ...[
                const SizedBox(height: AppSpacing.space2xs),
                TextButton(
                  onPressed: _sessionOrders.isEmpty ? null : _finishBatch,
                  child: const Text('Finish Batch'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _increment(MenuItemSnapshot item) {
    setState(() => _quantities[item.id] = (_quantities[item.id] ?? 0) + 1);
  }

  void _decrement(MenuItemSnapshot item) {
    final current = _quantities[item.id] ?? 0;
    if (current <= 1) {
      _remove(item);
    } else {
      setState(() => _quantities[item.id] = current - 1);
    }
  }

  void _remove(MenuItemSnapshot item) {
    setState(() => _quantities.remove(item.id));
  }

  Future<void> _showDiscountSheet() async {
    final controller = TextEditingController(
      text: _discount == 0 ? '' : '$_discount',
    );
    final amount = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.spaceMd,
              AppSpacing.spaceXs,
              AppSpacing.spaceMd,
              MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.spaceMd,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add Discount',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Discount',
                    prefixText: 'Rs  ',
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                FilledButton(
                  onPressed: () {
                    final value = int.tryParse(controller.text) ?? 0;
                    Navigator.of(sheetContext).pop(value);
                  },
                  child: const Text('Apply Discount'),
                ),
              ],
            ),
          ),
        );
      },
    );
    controller.dispose();
    if (amount != null && mounted) {
      setState(() => _discount = amount.clamp(0, _subtotal));
    }
  }

  Future<void> _showNoteSheet() async {
    final controller = TextEditingController(text: _notes);
    final note = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.spaceMd,
              AppSpacing.spaceXs,
              AppSpacing.spaceMd,
              MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.spaceMd,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Order Note',
                  style: Theme.of(
                    sheetContext,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                TextField(
                  controller: controller,
                  autofocus: true,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Add a useful note about this order',
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(sheetContext).pop(controller.text.trim()),
                  child: const Text('Save Note'),
                ),
              ],
            ),
          ),
        );
      },
    );
    controller.dispose();
    if (note != null && mounted) setState(() => _notes = note);
  }

  Future<void> _saveOrder() async {
    if (_subtotal == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one menu item.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 650));
      if (!mounted) return;

      if (widget.isBatchMode) {
        final savedNumber =
            _editingSessionOrderNumber ??
            '#${_orderSequence.toString().padLeft(4, '0')}';
        setState(() {
          _sessionOrders.add(
            _BatchOrderSummary(
              orderNumber: savedNumber,
              channel: _channel,
              total: _subtotal - _discount,
              quantities: Map<String, int>.of(_quantities),
              discount: _discount,
              notes: _notes,
            ),
          );
          if (_editingSessionOrderNumber == null) _orderSequence++;
          _editingSessionOrderNumber = null;
          _quantities.clear();
          _discount = 0;
          _notes = null;
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order saved. Ready for the next bill.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Order updated' : 'Order saved')),
        );
        Navigator.of(context).pop(true);
      }
    } on Exception {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Couldn't save order. Your order is still here. Check your connection and try again.",
          ),
        ),
      );
    }
  }

  void _finishBatch() {
    Navigator.of(context).pop(_sessionOrders.length);
  }

  void _editSessionOrder(_BatchOrderSummary order) {
    setState(() {
      _sessionOrders.remove(order);
      _editingSessionOrderNumber = order.orderNumber;
      _channel = order.channel;
      _quantities
        ..clear()
        ..addAll(order.quantities);
      _discount = order.discount;
      _notes = order.notes;
    });
  }
}

class _BatchHeader extends StatelessWidget {
  const _BatchHeader({required this.orderCount, required this.total});

  final int orderCount;
  final int total;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();
    final theme = Theme.of(context);

    return AppCard(
      color: AppColors.splashAccent.withValues(alpha: .28),
      borderColor: AppColors.primary.withValues(alpha: .12),
      borderRadius: AppRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Enter today's orders quickly.",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            'Aug 16, 2026',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.spaceMd),
          Row(
            children: [
              Expanded(child: Text('$orderCount orders entered')),
              Text(
                'Rs ${currency.format(total)} total',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionOrdersCard extends StatelessWidget {
  const _SessionOrdersCard({required this.orders, required this.onOrderTap});

  final List<_BatchOrderSummary> orders;
  final ValueChanged<_BatchOrderSummary> onOrderTap;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.decimalPattern();

    return AppCard(
      borderRadius: AppRadius.lg,
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: const Text(
          'Orders Added This Session',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        children: [
          for (final order in orders)
            ListTile(
              onTap: () => onOrderTap(order),
              contentPadding: EdgeInsets.zero,
              title: Text(order.orderNumber),
              subtitle: Text(order.channel.label),
              trailing: Text(
                'Rs ${currency.format(order.total)}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
        ],
      ),
    );
  }
}

class _BatchOrderSummary {
  const _BatchOrderSummary({
    required this.orderNumber,
    required this.channel,
    required this.total,
    required this.quantities,
    required this.discount,
    required this.notes,
  });

  final String orderNumber;
  final OrderChannel channel;
  final int total;
  final Map<String, int> quantities;
  final int discount;
  final String? notes;
}
