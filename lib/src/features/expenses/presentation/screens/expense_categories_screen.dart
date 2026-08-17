import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../domain/models/expense.dart';
import '../widgets/expense_category_widgets.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class ExpenseCategoriesScreen extends StatefulWidget {
  const ExpenseCategoriesScreen({super.key});

  @override
  State<ExpenseCategoriesScreen> createState() =>
      _ExpenseCategoriesScreenState();
}

class _ExpenseCategoriesScreenState extends State<ExpenseCategoriesScreen> {
  late final List<_CategorySetting> _categories = ExpenseCategories.defaults
      .map(
        (name) => _CategorySetting(
          name: name,
          type: ExpenseCategories.suggestedType(name),
          isDefault: true,
        ),
      )
      .toList();

  int get _fixedCount => _categories
      .where((category) => category.type == ExpenseType.fixed)
      .length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Expense Categories',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('expense-category-add-button'),
        tooltip: 'Add category',
        backgroundColor: AppColors.expenseAccent,
        foregroundColor: AppColors.surface,
        onPressed: _addCategory,
        child: const AppIcon(AppIcons.add_rounded),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceMd,
            AppSpacing.spaceSm,
            AppSpacing.spaceMd,
            AppSpacing.space6xl,
          ),
          children: [
            ExpenseCategorySummaryCard(
              categoryCount: _categories.length,
              fixedCount: _fixedCount,
            ),
            const SizedBox(height: AppSpacing.spaceLg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Categories',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${_categories.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral600,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.neutral300),
              ),
              child: Column(
                children: [
                  for (var index = 0; index < _categories.length; index++) ...[
                    ExpenseCategoryTile(
                      name: _categories[index].name,
                      type: _categories[index].type,
                      onRename: () => _editCategory(index),
                      onDelete: _categories[index].isDefault
                          ? null
                          : () => _confirmDelete(index),
                    ),
                    if (index != _categories.length - 1)
                      const AppDivider(height: 1, indent: AppSpacing.spaceMd),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              'Built-in categories can be renamed. Custom categories can also be deleted when no expenses use them.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.neutral600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCategory() async {
    final result = await _showEditor();
    if (!mounted || result == null) return;
    setState(
      () => _categories.add(
        _CategorySetting(
          name: result.name,
          type: result.type,
          isDefault: false,
        ),
      ),
    );
  }

  Future<void> _editCategory(int index) async {
    final category = _categories[index];
    final result = await _showEditor(category: category);
    if (!mounted || result == null) return;
    setState(
      () => _categories[index] = category.copyWith(
        name: result.name,
        type: result.type,
      ),
    );
  }

  Future<ExpenseCategoryEditorResult?> _showEditor({
    _CategorySetting? category,
  }) {
    return showModalBottomSheet<ExpenseCategoryEditorResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (context) => ExpenseCategoryEditorSheet(
        initialName: category?.name,
        initialType: category?.type ?? ExpenseType.variable,
        existingNames: _categories
            .map((item) => item.name.toLowerCase())
            .toSet(),
      ),
    );
  }

  Future<void> _confirmDelete(int index) async {
    final category = _categories[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: 'Delete ${category.name}?',
        message:
            'This custom category will be removed from your expense organization.',
        confirmLabel: 'Delete',
        icon: AppIcons.delete_outline_rounded,
        isDestructive: true,
        confirmButtonKey: const ValueKey(
          'confirm-delete-expense-category-button',
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _categories.removeAt(index));
  }
}

class _CategorySetting {
  const _CategorySetting({
    required this.name,
    required this.type,
    required this.isDefault,
  });

  final String name;
  final ExpenseType type;
  final bool isDefault;

  _CategorySetting copyWith({String? name, ExpenseType? type}) =>
      _CategorySetting(
        name: name ?? this.name,
        type: type ?? this.type,
        isDefault: isDefault,
      );
}
