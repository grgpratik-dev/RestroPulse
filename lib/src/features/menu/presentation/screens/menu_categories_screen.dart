import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class MenuCategoriesScreen extends StatefulWidget {
  const MenuCategoriesScreen({super.key});

  @override
  State<MenuCategoriesScreen> createState() => _MenuCategoriesScreenState();
}

class _MenuCategoriesScreenState extends State<MenuCategoriesScreen> {
  final _categories = <_MenuCategory>[
    const _MenuCategory('Momo', 12),
    const _MenuCategory('Burgers', 7),
    const _MenuCategory('Pizza', 6),
    const _MenuCategory('Drinks', 9),
    const _MenuCategory('Snacks', 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Categories')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _editCategory,
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
                  'Organize items for faster menu management and order entry.',
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
                  vertical: 6,
                ),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4F5EF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.category_outlined,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${category.itemCount} items${category.isActive ? '' : ' · Inactive'}',
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
                    if (category.itemCount == 0)
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
      await _editCategory(index: index);
    } else if (action == 'status') {
      setState(() {
        final category = _categories[index];
        _categories[index] = category.copyWith(isActive: !category.isActive);
      });
    } else if (action == 'delete') {
      setState(() => _categories.removeAt(index));
    }
  }

  Future<void> _editCategory({int? index}) async {
    final controller = TextEditingController(
      text: index == null ? '' : _categories[index].name,
    );
    final name = await showModalBottomSheet<String>(
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
              index == null ? 'Add category' : 'Rename category',
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
              child: Text(index == null ? 'Add Category' : 'Save Name'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (!mounted || name == null || name.isEmpty) return;
    setState(() {
      if (index == null) {
        _categories.add(_MenuCategory(name, 0));
      } else {
        _categories[index] = _categories[index].copyWith(name: name);
      }
    });
  }
}

class _MenuCategory {
  const _MenuCategory(this.name, this.itemCount, {this.isActive = true});

  final String name;
  final int itemCount;
  final bool isActive;

  _MenuCategory copyWith({String? name, bool? isActive}) => _MenuCategory(
    name ?? this.name,
    itemCount,
    isActive: isActive ?? this.isActive,
  );
}
