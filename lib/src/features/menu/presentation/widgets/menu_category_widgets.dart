import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class MenuCategorySummaryCard extends StatelessWidget {
  const MenuCategorySummaryCard({
    required this.categoryCount,
    required this.itemCount,
    super.key,
  });

  final int categoryCount;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.mintSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.mintBright.withValues(alpha: 0.65)),
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
            '$itemCount menu items organized',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.neutral700,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuCategoryTile extends StatelessWidget {
  const MenuCategoryTile({
    required this.name,
    required this.onRename,
    required this.onDelete,
    super.key,
  });

  final String name;
  final VoidCallback onRename;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 74),
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
            PopupMenuButton<String>(
              tooltip: '$name category actions',
              onSelected: (action) {
                if (action == 'rename') onRename();
                if (action == 'delete') onDelete?.call();
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'rename', child: Text('Rename')),
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
              icon: SvgPicture.asset(AppIcons.more_vert_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCategoryEditorSheet extends StatefulWidget {
  const MenuCategoryEditorSheet({
    required this.existingNames,
    this.initialName,
    super.key,
  });

  final Set<String> existingNames;
  final String? initialName;

  @override
  State<MenuCategoryEditorSheet> createState() =>
      _MenuCategoryEditorSheetState();
}

class _MenuCategoryEditorSheetState extends State<MenuCategoryEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  bool get _isEditing => widget.initialName != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
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
                _isEditing ? 'Rename category' : 'Add category',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.space2xs),
              Text(
                'Use a short name staff can recognize quickly.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.neutral600,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceMd),
              TextFormField(
                key: const ValueKey('menu-category-name-field'),
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Category name',
                  hintText: 'e.g. Desserts',
                  prefixIcon: SvgPicture.asset(AppIcons.category_outlined),
                ),
                onFieldSubmitted: (_) => _submit(),
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
              SizedBox(
                height: 52,
                child: FilledButton(
                  key: const ValueKey('menu-category-submit-button'),
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
    Navigator.of(context).pop(_controller.text.trim());
  }
}
