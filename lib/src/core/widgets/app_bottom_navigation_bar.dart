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
    label: 'Screen 1',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  AppBottomNavigationItem(
    label: 'Screen 2',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
  AppBottomNavigationItem(
    label: 'Screen 3',
    icon: Icons.info_outline,
    selectedIcon: Icons.info,
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
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon ?? item.icon),
            label: item.label,
          ),
      ],
    );
  }
}
