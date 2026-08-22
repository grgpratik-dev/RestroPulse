import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/wastage.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class WastageFormScreen extends StatefulWidget {
  const WastageFormScreen({this.entry, super.key});

  final WastageEntry? entry;

  @override
  State<WastageFormScreen> createState() => _WastageFormScreenState();
}

class _WastageFormScreenState extends State<WastageFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _itemController;
  late final TextEditingController _lossController;
  late final TextEditingController _quantityController;
  late final TextEditingController _notesController;
  WastageReason? _reason;
  WastageUnit? _unit;
  late DateTime _date;
  bool _saving = false;

  bool get _editing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _itemController = TextEditingController(text: entry?.itemName);
    _lossController = TextEditingController(
      text: entry == null ? '' : entry.estimatedLoss.toStringAsFixed(0),
    );
    _quantityController = TextEditingController(
      text: entry?.quantity?.toString(),
    );
    _notesController = TextEditingController(text: entry?.notes);
    _reason = entry?.reason;
    _unit = entry?.unit;
    _date = entry?.date ?? DateTime(2026, 8, 16);
  }

  @override
  void dispose() {
    _itemController.dispose();
    _lossController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Edit Wastage' : 'Record Wastage')),
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
              : Text(_editing ? 'Save Changes' : 'Save Wastage'),
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
                'Record food loss quickly',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Wastage is tracked as a loss indicator, not another expense.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceLg),
              TextFormField(
                controller: _itemController,
                autofocus: !_editing,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Item or Ingredient',
                  hintText: 'e.g. Chicken',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter an item or ingredient'
                    : null,
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              TextFormField(
                controller: _lossController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Estimated Loss',
                  prefixText: 'Rs  ',
                ),
                validator: (value) => (double.tryParse(value ?? '') ?? 0) <= 0
                    ? 'Enter an estimated loss above 0'
                    : null,
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              Text(
                'Quick reasons',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                          WastageReason.overproduction,
                          WastageReason.expired,
                          WastageReason.preparationMistake,
                          WastageReason.damaged,
                        ]
                        .map(
                          (reason) => ChoiceChip(
                            label: Text(
                              reason == WastageReason.preparationMistake
                                  ? 'Prep Mistake'
                                  : reason.label,
                            ),
                            selected: _reason == reason,
                            onSelected: (_) => setState(() => _reason = reason),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              DropdownButtonFormField<WastageReason>(
                key: ValueKey(_reason),
                initialValue: _reason,
                decoration: const InputDecoration(labelText: 'Reason'),
                items: WastageReason.values
                    .map(
                      (reason) => DropdownMenuItem(
                        value: reason,
                        child: Text(reason.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _reason = value),
                validator: (_) => _reason == null ? 'Select a reason' : null,
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Quantity (optional)',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        return (double.tryParse(value) ?? -1) < 0
                            ? 'Cannot be negative'
                            : null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  Expanded(
                    child: DropdownButtonFormField<WastageUnit>(
                      initialValue: _unit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: WastageUnit.values
                          .map(
                            (unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _unit = value),
                    ),
                  ),
                ],
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (!mounted || date == null) return;
    setState(() => _date = date);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final quantity = _quantityController.text.isEmpty
        ? null
        : double.tryParse(_quantityController.text);
    final saved =
        widget.entry?.copyWith(
          itemName: _itemController.text.trim(),
          estimatedLoss: double.parse(_lossController.text),
          reason: _reason,
          date: _date,
          quantity: quantity,
          unit: _unit,
          notes: _notesController.text.trim(),
        ) ??
        WastageEntry(
          id: 'waste-${DateTime.now().microsecondsSinceEpoch}',
          itemName: _itemController.text.trim(),
          estimatedLoss: double.parse(_lossController.text),
          reason: _reason!,
          date: _date,
          quantity: quantity,
          unit: _unit,
          notes: _notesController.text.trim(),
        );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Wastage recorded')));
    Navigator.pop(context, saved);
  }
}
