import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/expense.dart';

class ExpenseFilterSelection {
  const ExpenseFilterSelection({
    this.category,
    this.type,
    this.sort = ExpenseSort.newest,
  });

  final String? category;
  final ExpenseType? type;
  final ExpenseSort sort;

  bool get isActive =>
      category != null || type != null || sort != ExpenseSort.newest;
}

Future<ExpenseFilterSelection?> showExpenseFilterSheet({
  required BuildContext context,
  required ExpenseFilterSelection initial,
}) {
  return showModalBottomSheet<ExpenseFilterSelection>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ExpenseFilterSheet(initial: initial),
  );
}

class _ExpenseFilterSheet extends StatefulWidget {
  const _ExpenseFilterSheet({required this.initial});

  final ExpenseFilterSelection initial;

  @override
  State<_ExpenseFilterSheet> createState() => _ExpenseFilterSheetState();
}

class _ExpenseFilterSheetState extends State<_ExpenseFilterSheet> {
  late String? _category = widget.initial.category;
  late ExpenseType? _type = widget.initial.type;
  late ExpenseSort _sort = widget.initial.sort;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Filter Expenses',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _category = null;
                    _type = null;
                    _sort = ExpenseSort.newest;
                  }),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            DropdownButtonFormField<String?>(
              initialValue: _category,
              decoration: const InputDecoration(hintText: 'All categories'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All categories'),
                ),
                ...ExpenseCategories.defaults.map(
                  (category) =>
                      DropdownMenuItem(value: category, child: Text(category)),
                ),
              ],
              onChanged: (value) => setState(() => _category = value),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            const Text(
              'Expense type',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            SegmentedButton<ExpenseType?>(
              segments: const [
                ButtonSegment(value: null, label: Text('All')),
                ButtonSegment(value: ExpenseType.fixed, label: Text('Fixed')),
                ButtonSegment(
                  value: ExpenseType.variable,
                  label: Text('Variable'),
                ),
              ],
              selected: {_type},
              showSelectedIcon: false,
              onSelectionChanged: (values) =>
                  setState(() => _type = values.first),
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            const Text('Sort', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.spaceXs),
            DropdownButtonFormField<ExpenseSort>(
              initialValue: _sort,
              items: ExpenseSort.values
                  .map(
                    (sort) =>
                        DropdownMenuItem(value: sort, child: Text(sort.label)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _sort = value);
              },
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(
                  context,
                  ExpenseFilterSelection(
                    category: _category,
                    type: _type,
                    sort: _sort,
                  ),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
