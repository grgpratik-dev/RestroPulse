import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/menu_item.dart';

enum MenuSortOption {
  bestSelling('Best Selling'),
  highestRevenue('Highest Revenue'),
  highestMargin('Highest Margin'),
  lowestMargin('Lowest Margin'),
  name('Name');

  const MenuSortOption(this.label);
  final String label;
}

class MenuSearchField extends StatelessWidget {
  const MenuSearchField({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        hintText: 'Search menu items',
        prefixIcon: Icon(Icons.search_rounded),
      ),
    );
  }
}

class MenuCategoryFilter extends StatelessWidget {
  const MenuCategoryFilter({
    required this.categories,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.spaceXs),
        itemBuilder: (context, index) {
          final category = categories[index];
          return FilterChip(
            label: Text(category),
            selected: selected == category,
            onSelected: (_) => onSelected(category),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

class MenuPerformanceFilter extends StatelessWidget {
  const MenuPerformanceFilter({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final MenuPerformanceStatus? selected;
  final ValueChanged<MenuPerformanceStatus?> onSelected;

  static const _options = <(String, MenuPerformanceStatus?)>[
    ('All', null),
    ('Stars', MenuPerformanceStatus.star),
    ('Review', MenuPerformanceStatus.reviewCost),
    ('Promote', MenuPerformanceStatus.promote),
    ('Low', MenuPerformanceStatus.lowPerformer),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _options.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.spaceXs),
        itemBuilder: (context, index) {
          final option = _options[index];
          return ChoiceChip(
            label: Text(option.$1),
            selected: selected == option.$2,
            onSelected: (_) => onSelected(option.$2),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

class MenuSortControl extends StatelessWidget {
  const MenuSortControl({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final MenuSortOption value;
  final ValueChanged<MenuSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuSortOption>(
      initialValue: value,
      onSelected: onChanged,
      position: PopupMenuPosition.under,
      itemBuilder: (context) => MenuSortOption.values
          .map(
            (option) => PopupMenuItem(
              value: option,
              child: Row(
                children: [
                  Expanded(child: Text(option.label)),
                  if (option == value)
                    Icon(
                      Icons.check_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
            ),
          )
          .toList(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sort: ${value.label}',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        ],
      ),
    );
  }
}
