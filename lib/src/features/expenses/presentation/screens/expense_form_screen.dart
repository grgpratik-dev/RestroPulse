import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/dependency_injection.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/bloc/image_picker/image_picker_bloc.dart';
import '../../domain/models/expense.dart';
import '../widgets/expense_receipt_picker.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class ExpenseFormScreen extends StatelessWidget {
  const ExpenseFormScreen({this.expense, super.key});

  final Expense? expense;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ImagePickerBloc>(),
      child: _ExpenseForm(expense: expense),
    );
  }
}

class _ExpenseForm extends StatefulWidget {
  const _ExpenseForm({this.expense});

  final Expense? expense;

  @override
  State<_ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<_ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _notesController;
  final _categories = [...ExpenseCategories.defaults];
  late DateTime _date;
  String? _category;
  ExpenseType _type = ExpenseType.variable;
  bool _saving = false;

  bool get _editing => widget.expense != null;
  double get _amount => double.tryParse(_amountController.text) ?? 0;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _amountController = TextEditingController(
      text: expense == null ? '' : expense.amount.toStringAsFixed(0),
    );
    _descriptionController = TextEditingController(text: expense?.description);
    _notesController = TextEditingController(text: expense?.notes);
    _date = expense?.date ?? DateTime(2026, 8, 16);
    _category = expense?.category;
    _type = expense?.type ?? ExpenseType.variable;
    if (_category != null && !_categories.contains(_category)) {
      _categories.add(_category!);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
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
        SnackBar(
          content: Text(state.errorMessage ?? 'Could not attach receipt.'),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text(_editing ? 'Edit Expense' : 'Add Expense')),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.all(AppSpacing.spaceMd),
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(_editing ? 'Save Changes' : 'Save Expense'),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Text(
                  'Quick entry',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Record the amount and what it was for.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceLg),
                TextFormField(
                  controller: _amountController,
                  autofocus: !_editing,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: 'Rs  ',
                    hintText: '0',
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (value) => (double.tryParse(value ?? '') ?? 0) <= 0
                      ? 'Enter an amount above 0'
                      : null,
                ),
                if (_amount >= 100000) ...[
                  const SizedBox(height: AppSpacing.spaceXs),
                  const Text(
                    'This is a large expense. Please confirm the amount.',
                    style: TextStyle(
                      color: AppColors.expenseForeground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.spaceMd),
                Text(
                  'Recent categories',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.spaceXs),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Ingredients', 'Packaging', 'Utilities']
                      .map(
                        (category) => ChoiceChip(
                          label: Text(category),
                          selected: _category == category,
                          onSelected: (_) => _selectCategory(category),
                        ),
                      )
                      .toList(),
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
                    } else if (value != null) {
                      _selectCategory(value);
                    }
                  },
                  validator: (_) =>
                      _category == null ? 'Select a category' : null,
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                TextFormField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Chicken supplier',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a short description'
                      : null,
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: SvgPicture.asset(
                        AppIcons.calendar_today_outlined,
                      ),
                    ),
                    child: Text(DateFormat('MMM d, yyyy').format(_date)),
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                Text(
                  'Expense type',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.spaceXs),
                SegmentedButton<ExpenseType>(
                  segments: ExpenseType.values
                      .map(
                        (type) =>
                            ButtonSegment(value: type, label: Text(type.label)),
                      )
                      .toList(),
                  selected: {_type},
                  showSelectedIcon: false,
                  onSelectionChanged: (values) =>
                      setState(() => _type = values.first),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                TextFormField(
                  controller: _notesController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    hintText: 'Add any useful details',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceMd),
                ExpenseReceiptPicker(initialPath: widget.expense?.receiptPath),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectCategory(String category) {
    setState(() {
      _category = category;
      _type = ExpenseCategories.suggestedType(category);
    });
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (!mounted || selected == null) return;
    setState(() => _date = selected);
  }

  Future<void> _addCategory() async {
    final controller = TextEditingController();
    final value = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add expense category',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Category name'),
            ),
            const SizedBox(height: 16),
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
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final receipt = context.read<ImagePickerBloc>().state.image?.path;
    final saved =
        widget.expense?.copyWith(
          amount: _amount,
          category: _category,
          description: _descriptionController.text.trim(),
          date: _date,
          type: _type,
          notes: _notesController.text.trim(),
          receiptPath: receipt,
        ) ??
        Expense(
          id: 'expense-${DateTime.now().microsecondsSinceEpoch}',
          amount: _amount,
          category: _category!,
          description: _descriptionController.text.trim(),
          date: _date,
          type: _type,
          notes: _notesController.text.trim(),
          receiptPath: receipt,
        );
    Navigator.pop(context, saved);
  }
}
