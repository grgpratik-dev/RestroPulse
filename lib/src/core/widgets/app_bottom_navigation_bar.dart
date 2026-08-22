import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

/// Describes a destination displayed by [AppBottomNavigationBar].
///

class AppBottomNavigationItem {
  const AppBottomNavigationItem({required this.label, required this.iconAsset});

  final String label;
  final String iconAsset;
}

List<AppBottomNavigationItem> items = [
  AppBottomNavigationItem(label: 'Dashboard', iconAsset: AppIcons.dashboard),
  AppBottomNavigationItem(
    label: 'Sales',
    iconAsset: AppIcons.receipt_long_outlined,
  ),
  AppBottomNavigationItem(
    label: 'Expenses',
    iconAsset: AppIcons.account_balance_wallet_outlined,
  ),
  AppBottomNavigationItem(
    label: 'Menu',
    iconAsset: AppIcons.restaurant_menu_rounded,
  ),
  AppBottomNavigationItem(
    label: 'Reports',
    iconAsset: AppIcons.analytics_outlined,
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
