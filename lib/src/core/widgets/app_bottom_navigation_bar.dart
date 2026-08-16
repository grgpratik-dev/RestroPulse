import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';

import '../../../gen/assets.gen.dart';

/// Describes a destination displayed by [AppBottomNavigationBar].
///

class AppBottomNavigationItem {
  const AppBottomNavigationItem({
    required this.label,
    required this.iconAsset,
    required this.selectedIconAsset,
  });

  final String label;
  final String iconAsset;
  final String selectedIconAsset;
}

List<AppBottomNavigationItem> items = [
  AppBottomNavigationItem(
    label: 'Dashboard',
    iconAsset: Assets.icons.navigation.dashboardOutlined,
    selectedIconAsset: Assets.icons.navigation.dashboardFilled,
  ),
  AppBottomNavigationItem(
    label: 'Sales',
    iconAsset: Assets.icons.navigation.salesOutlined,
    selectedIconAsset: Assets.icons.navigation.salesFilled,
  ),
  AppBottomNavigationItem(
    label: 'Expenses',
    iconAsset: Assets.icons.navigation.expensesOutlined,
    selectedIconAsset: Assets.icons.navigation.expensesFilled,
  ),
  AppBottomNavigationItem(
    label: 'Menu',
    iconAsset: Assets.icons.navigation.menuOutlined,
    selectedIconAsset: Assets.icons.navigation.menuFilled,
  ),
  AppBottomNavigationItem(
    label: 'Reports',
    iconAsset: Assets.icons.navigation.reportsOutlined,
    selectedIconAsset: Assets.icons.navigation.reportsFilled,
  ),
];

/// The shared bottom navigation bar used by the application's main shells.
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        for (final item in items)
          BottomNavigationBarItem(
            icon: _NavigationSvg(asset: item.iconAsset),
            activeIcon: _NavigationSvg(asset: item.selectedIconAsset),
            label: item.label,
          ),
      ],
      currentIndex: selectedIndex,
      onTap: onDestinationSelected,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.neutral500,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }
}

class _NavigationSvg extends StatelessWidget {
  const _NavigationSvg({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color ?? AppColors.neutral500;

    return Transform.translate(
      offset: const Offset(0, 4),
      child: SvgPicture.asset(
        asset,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
