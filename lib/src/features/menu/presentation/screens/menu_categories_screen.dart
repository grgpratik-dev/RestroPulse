import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/widgets/app_divider.dart';
import '../widgets/menu_category_widgets.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

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

  int get _totalItems =>
      _categories.fold(0, (total, category) => total + category.itemCount);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Menu Categories',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('menu-category-add-button'),
        tooltip: 'Add category',
        onPressed: _editCategory,
        child: SvgPicture.asset(AppIcons.add_rounded, width: 30, height: 30),
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
            MenuCategorySummaryCard(
              categoryCount: _categories.length,
              itemCount: _totalItems,
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
                    MenuCategoryTile(
                      name: _categories[index].name,
                      onRename: () => _editCategory(index: index),
                      onDelete: _categories[index].itemCount == 0
                          ? () => _confirmDelete(index)
                          : null,
                    ),
                    if (index != _categories.length - 1)
                      const AppDivider(height: 1, indent: AppSpacing.spaceMd),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            Text(
              'A category can be deleted after all of its menu items are moved or removed.',
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

  Future<void> _editCategory({int? index}) async {
    final existingNames = _categories
        .map((category) => category.name.toLowerCase())
        .toSet();
    final name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (context) => MenuCategoryEditorSheet(
        initialName: index == null ? null : _categories[index].name,
        existingNames: existingNames,
      ),
    );
    if (!mounted || name == null) return;

    setState(() {
      if (index == null) {
        _categories.add(_MenuCategory(name, 0));
      } else {
        _categories[index] = _categories[index].copyWith(name: name);
      }
    });
  }

  Future<void> _confirmDelete(int index) async {
    final category = _categories[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppConfirmationDialog(
        title: 'Delete ${category.name}?',
        message: 'This category will be removed from your menu organization.',
        confirmLabel: 'Delete',
        icon: AppIcons.delete_outline_rounded,
        isDestructive: true,
        confirmButtonKey: const ValueKey('confirm-delete-category-button'),
      ),
    );
    if (confirmed != true) return;
    setState(() => _categories.removeAt(index));
  }
}

class _MenuCategory {
  const _MenuCategory(this.name, this.itemCount);

  final String name;
  final int itemCount;

  _MenuCategory copyWith({String? name}) =>
      _MenuCategory(name ?? this.name, itemCount);
}
