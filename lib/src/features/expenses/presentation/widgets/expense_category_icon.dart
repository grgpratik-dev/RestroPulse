import 'package:flutter/material.dart';

IconData expenseCategoryIcon(String category) => switch (category) {
  'Ingredients' => Icons.shopping_basket_outlined,
  'Salaries' => Icons.groups_outlined,
  'Rent' => Icons.store_outlined,
  'Utilities' => Icons.bolt_outlined,
  'Packaging' => Icons.inventory_2_outlined,
  'Gas' => Icons.local_fire_department_outlined,
  'Delivery Fees' => Icons.delivery_dining_outlined,
  'Marketing' => Icons.campaign_outlined,
  'Repairs & Maintenance' => Icons.handyman_outlined,
  'Equipment' => Icons.kitchen_outlined,
  _ => Icons.receipt_long_outlined,
};

class ExpenseCategoryIcon extends StatelessWidget {
  const ExpenseCategoryIcon({
    required this.category,
    this.size = 44,
    super.key,
  });

  final String category;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2DF),
        borderRadius: BorderRadius.circular(size * 0.27),
      ),
      child: Icon(
        expenseCategoryIcon(category),
        color: const Color(0xFFB45309),
        size: size * 0.5,
      ),
    );
  }
}
