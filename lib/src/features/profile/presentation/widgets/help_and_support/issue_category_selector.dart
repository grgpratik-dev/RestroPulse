import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class IssueCategorySelector extends StatelessWidget {
  const IssueCategorySelector({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: const ValueKey('issue-category-field'),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Issue Category',
        hintText: 'Select a category',
        prefixIcon: SvgPicture.asset(
          AppIcons.category_outlined,
          width: 22,
          height: 22,
        ),
      ),
      items: [
        for (final item in items)
          DropdownMenuItem<String>(value: item, child: Text(item)),
      ],
      onChanged: onChanged,
      validator: (selection) {
        if (selection == null) return 'Please select an issue category.';
        return null;
      },
    );
  }
}
