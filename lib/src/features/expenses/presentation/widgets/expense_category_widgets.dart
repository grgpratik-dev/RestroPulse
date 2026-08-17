import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/expense.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class ExpenseCategorySummaryCard extends StatelessWidget {
  const ExpenseCategorySummaryCard({
    required this.categoryCount,
    required this.fixedCount,
    super.key,
  });

  final int categoryCount;
  final int fixedCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final variableCount = categoryCount - fixedCount;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.expenseSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.expenseBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$categoryCount categories',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.space2xs),
          Text(
            '$fixedCount fixed · $variableCount variable',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseCategoryTile extends StatelessWidget {
  const ExpenseCategoryTile({
    required this.name,
    required this.type,
    required this.onRename,
    required this.onDelete,
    super.key,
  });

  final String name;
  final ExpenseType type;
  final VoidCallback onRename;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 68),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceMd,
          vertical: AppSpacing.spaceSm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceSm,
                vertical: AppSpacing.space2xs,
              ),
              decoration: BoxDecoration(
                color: type == ExpenseType.fixed
                    ? AppColors.neutral100
                    : AppColors.expenseSurface,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                type.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: type == ExpenseType.fixed
                      ? AppColors.neutral700
                      : AppColors.expenseForeground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            PopupMenuButton<String>(
              tooltip: '$name category actions',
              onSelected: (action) {
                if (action == 'rename') onRename();
                if (action == 'delete') onDelete?.call();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'rename', child: Text('Edit')),
                if (onDelete != null)
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
              icon: const AppIcon(AppIcons.more_vert_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseCategoryEditorResult {
  const ExpenseCategoryEditorResult({required this.name, required this.type});

  final String name;
  final ExpenseType type;
}

class ExpenseCategoryEditorSheet extends StatefulWidget {
  const ExpenseCategoryEditorSheet({
    required this.existingNames,
    required this.initialType,
    this.initialName,
    super.key,
  });

  final Set<String> existingNames;
  final String? initialName;
  final ExpenseType initialType;

  @override
  State<ExpenseCategoryEditorSheet> createState() =>
      _ExpenseCategoryEditorSheetState();
}

class _ExpenseCategoryEditorSheetState
    extends State<ExpenseCategoryEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  late ExpenseType _type;

  bool get _isEditing => widget.initialName != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.spaceLg,
          AppSpacing.spaceXs,
          AppSpacing.spaceLg,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.spaceLg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'Edit category' : 'Add category',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.space2xs),
              Text(
                'Choose how this expense behaves in your reports.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.neutral600,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              TextFormField(
                key: const ValueKey('expense-category-name-field'),
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Category name',
                  hintText: 'e.g. Insurance',
                ),
                validator: (value) {
                  final name = value?.trim() ?? '';
                  if (name.isEmpty) return 'Enter a category name';
                  final unchanged =
                      name.toLowerCase() == widget.initialName?.toLowerCase();
                  if (!unchanged &&
                      widget.existingNames.contains(name.toLowerCase())) {
                    return 'This category already exists';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              DropdownButtonFormField<ExpenseType>(
                key: const ValueKey('expense-category-type-field'),
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Expense type'),
                items: ExpenseType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      ),
                    )
                    .toList(),
                onChanged: (type) {
                  if (type != null) _type = type;
                },
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              SizedBox(
                height: 52,
                child: FilledButton(
                  key: const ValueKey('expense-category-submit-button'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.expenseAccent,
                    foregroundColor: AppColors.surface,
                  ),
                  onPressed: _submit,
                  child: Text(_isEditing ? 'Save changes' : 'Add category'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      ExpenseCategoryEditorResult(name: _controller.text.trim(), type: _type),
    );
  }
}
