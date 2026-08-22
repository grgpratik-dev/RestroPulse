import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

import '../../../../app/theme/app_colors.dart';

String expenseCategoryIconAsset(String category) => switch (category) {
  'Ingredients' => AppIcons.expenseIngredients,
  'Salaries' => AppIcons.expenseSalaries,
  'Rent' => AppIcons.expenseRent,
  'Utilities' => AppIcons.expenseUtilities,
  'Packaging' => AppIcons.expensePackaging,
  'Gas' => AppIcons.expenseGas,
  'Delivery Fees' => AppIcons.expenseDeliveryFees,
  'Marketing' => AppIcons.expenseMarketing,
  'Repairs & Maintenance' => AppIcons.expenseRepairs,
  'Equipment' => AppIcons.expenseEquipment,
  'Miscellaneous' => AppIcons.expenseMiscellaneous,
  _ => AppIcons.expenseOther,
};

class ExpenseCategoryIcon extends StatelessWidget {
  const ExpenseCategoryIcon({
    required this.category,
    this.size = 40,
    super.key,
  });

  final String category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(AppSpacing.space2xs),
      decoration: BoxDecoration(
        color: AppColors.expenseSurface,
        borderRadius: BorderRadius.circular(size * 0.27),
      ),
      child: Center(
        child: SvgPicture.asset(
          expenseCategoryIconAsset(category),
          width: size * 0.45,
          height: size * 0.45,
          colorFilter: const ColorFilter.mode(
            AppColors.expenseForeground,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
