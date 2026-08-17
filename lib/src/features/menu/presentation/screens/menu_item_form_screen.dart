import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/dependency_injection.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/bloc/image_picker/image_picker_bloc.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../domain/models/menu_item.dart';
import '../widgets/menu_item_form_widgets.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class MenuItemFormScreen extends StatelessWidget {
  const MenuItemFormScreen({this.item, super.key});

  final MenuItem? item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ImagePickerBloc>(),
      child: _MenuItemForm(item: item),
    );
  }
}

class _MenuItemForm extends StatefulWidget {
  const _MenuItemForm({this.item});

  final MenuItem? item;

  @override
  State<_MenuItemForm> createState() => _MenuItemFormState();
}

class _MenuItemFormState extends State<_MenuItemForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _costController;
  late final TextEditingController _notesController;
  final _categories = <String>['Momo', 'Burgers', 'Pizza', 'Drinks', 'Snacks'];
  String? _category;
  bool _isSaving = false;

  bool get _isEditing => widget.item != null;
  double get _price => double.tryParse(_priceController.text) ?? 0;
  double get _cost => double.tryParse(_costController.text) ?? 0;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item?.name);
    _priceController = TextEditingController(
      text: item == null ? '' : item.sellingPrice.toStringAsFixed(0),
    );
    _costController = TextEditingController(
      text: item == null ? '' : item.estimatedCost.toStringAsFixed(0),
    );
    _notesController = TextEditingController(text: item?.notes);
    _category = item?.category;
    if (_category != null && !_categories.contains(_category)) {
      _categories.add(_category!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImagePickerBloc, ImagePickerState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == ImagePickerStatus.failure,
      listener: (context, state) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Could not add photo.')),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Menu Item' : 'Add Menu Item'),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.all(AppSpacing.spaceMd),
          child: FilledButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(_isEditing ? 'Save Changes' : 'Save Item'),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spaceMd,
                AppSpacing.spaceSm,
                AppSpacing.spaceMd,
                AppSpacing.spaceLg,
              ),
              children: [
                Text(
                  _isEditing
                      ? 'Update current pricing for future orders.'
                      : 'Add the basics now. You can refine them anytime.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceLg),
                MenuPhotoPicker(initialPath: widget.item?.imagePath),
                const SizedBox(height: AppSpacing.spaceLg),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Item name',
                    hintText: 'Chicken Momo',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter an item name'
                      : null,
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                DropdownButtonFormField<String>(
                  key: ValueKey(_category),
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    ..._categories.map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    ),
                    const DropdownMenuItem(
                      value: '__add__',
                      child: Text('+ Add New Category'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == '__add__') {
                      _addCategory();
                    } else {
                      setState(() => _category = value);
                    }
                  },
                  validator: (value) =>
                      _category == null ? 'Select a category' : null,
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Selling price',
                          prefixText: 'Rs  ',
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (value) =>
                            (double.tryParse(value ?? '') ?? 0) <= 0
                            ? 'Enter a price above 0'
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spaceSm),
                    Expanded(
                      child: TextFormField(
                        controller: _costController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Estimated cost',
                          prefixText: 'Rs  ',
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (value) {
                          final cost = double.tryParse(value ?? '');
                          if (cost == null) return 'Enter a cost';
                          return cost < 0 ? 'Cannot be negative' : null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                if (_cost > _price && _price > 0) ...[
                  const MenuCostWarning(),
                  const SizedBox(height: AppSpacing.spaceMd),
                ],
                MenuCostPreview(sellingPrice: _price, estimatedCost: _cost),
                const SizedBox(height: AppSpacing.spaceMd),
                TextFormField(
                  controller: _notesController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    hintText: 'Add a short note about this item',
                    alignLabelWithHint: true,
                  ),
                ),
                if (_isEditing) ...[
                  const SizedBox(height: AppSpacing.spaceMd),
                  Text(
                    'Historical orders keep the price and cost stored when each sale was recorded.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addCategory() async {
    final controller = TextEditingController();
    final value = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.spaceLg,
          AppSpacing.spaceLg,
          AppSpacing.spaceLg,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.spaceLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add category',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Category name'),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (!mounted || value == null || value.isEmpty) return;
    setState(() {
      if (!_categories.contains(value)) _categories.add(value);
      _category = value;
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final duplicate = MenuMockData.items.any(
      (item) =>
          item.id != widget.item?.id &&
          item.name.toLowerCase() == _nameController.text.trim().toLowerCase(),
    );
    if (duplicate) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (context) => const AppConfirmationDialog(
          title: 'Similar item already exists',
          message:
              'An item with this name is already on your menu. Save it anyway?',
          confirmLabel: 'Save Anyway',
          cancelLabel: 'Review',
          icon: AppIcons.content_copy_outlined,
        ),
      );
      if (proceed != true || !mounted) return;
    }

    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    final imagePath = context.read<ImagePickerBloc>().state.image?.path;
    final savedItem =
        widget.item?.copyWith(
          name: _nameController.text.trim(),
          category: _category,
          sellingPrice: _price,
          estimatedCost: _cost,
          notes: _notesController.text.trim(),
          imagePath: imagePath,
        ) ??
        MenuItem(
          id: 'menu-${DateTime.now().microsecondsSinceEpoch}',
          name: _nameController.text.trim(),
          category: _category!,
          sellingPrice: _price,
          estimatedCost: _cost,
          unitsSold: 0,
          revenue: 0,
          historicalCost: 0,
          ordersContainingItem: 0,
          notes: _notesController.text.trim(),
          imagePath: imagePath,
        );
    Navigator.pop(context, savedItem);
  }
}
