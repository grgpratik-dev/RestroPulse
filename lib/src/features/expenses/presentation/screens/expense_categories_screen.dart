import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/expense.dart';
import '../widgets/expense_category_icon.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Categories')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCategory,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Category'),
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          itemCount: _categories.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Categories remain attached to historical expenses even when deactivated.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }
            final itemIndex = index - 1;
            final category = _categories[itemIndex];
            return Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spaceMd,
                  vertical: 5,
                ),
                leading: ExpenseCategoryIcon(category: category.name),
                title: Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${category.type.label}${category.isActive ? '' : ' · Inactive'}',
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (action) => _handleAction(action, itemIndex),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'rename', child: Text('Rename')),
                    PopupMenuItem(
                      value: 'status',
                      child: Text(
                        category.isActive ? 'Deactivate' : 'Reactivate',
                      ),
                    ),
                    if (!category.isDefault)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleAction(String action, int index) async {
    if (action == 'rename') {
      final name = await _askForName(initial: _categories[index].name);
      if (!mounted || name == null) return;
      setState(
        () => _categories[index] = _categories[index].copyWith(name: name),
      );
    } else if (action == 'status') {
      setState(() {
        final category = _categories[index];
        _categories[index] = category.copyWith(isActive: !category.isActive);
      });
    } else if (action == 'delete') {
      setState(() => _categories.removeAt(index));
    }
  }

  Future<void> _addCategory() async {
    final name = await _askForName();
    if (!mounted || name == null) return;
    setState(
      () => _categories.add(
        _CategorySetting(
          name: name,
          type: ExpenseType.variable,
          isDefault: false,
        ),
      ),
    );
  }

  Future<String?> _askForName({String initial = ''}) async {
    final controller = TextEditingController(text: initial);
    final result = await showModalBottomSheet<String>(
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
              initial.isEmpty ? 'Add category' : 'Rename category',
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
              child: const Text('Save Category'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    return result == null || result.isEmpty ? null : result;
  }
}

class _CategorySetting {
  const _CategorySetting({
    required this.name,
    required this.type,
    required this.isDefault,
    this.isActive = true,
  });

  final String name;
  final ExpenseType type;
  final bool isDefault;
  final bool isActive;

  _CategorySetting copyWith({String? name, bool? isActive}) => _CategorySetting(
    name: name ?? this.name,
    type: type,
    isDefault: isDefault,
    isActive: isActive ?? this.isActive,
  );
}
