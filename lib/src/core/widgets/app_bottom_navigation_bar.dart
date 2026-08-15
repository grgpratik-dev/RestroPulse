import 'package:flutter/material.dart';

/// Describes a destination displayed by [AppBottomNavigationBar].
///

class AppBottomNavigationItem {
  const AppBottomNavigationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
}

final List<AppBottomNavigationItem> items = const [
  AppBottomNavigationItem(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
  ),
  AppBottomNavigationItem(
    label: 'Sales',
    icon: Icons.shopping_cart_outlined,
    selectedIcon: Icons.shopping_cart,
  ),
  AppBottomNavigationItem(
    label: 'Expenses',
    icon: Icons.local_atm_outlined,
    selectedIcon: Icons.local_atm,
  ),
  AppBottomNavigationItem(
    label: 'Menu',
    icon: Icons.menu,
    selectedIcon: Icons.menu,
  ),
  AppBottomNavigationItem(
    label: 'Reports',
    icon: Icons.bar_chart_outlined,
    selectedIcon: Icons.bar_chart,
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
            icon: Icon(item.icon),
            activeIcon: Icon(item.selectedIcon ?? item.icon),
            label: item.label,
          ),
      ],
      currentIndex: selectedIndex,
      onTap: onDestinationSelected,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }
}
