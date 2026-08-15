import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/gen/assets.gen.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/core/widgets/app_bottom_navigation_bar.dart';
import 'package:restropulse/src/core/widgets/app_name.dart';

import '../../../../app/router/app_route.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 84,
        titleSpacing: 24,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Semantics(
          label: 'RestroPulse',
          header: true,
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Assets.logo.applogo.path,
                  key: const ValueKey('main-app-bar-logo'),
                  width: 34,
                  height: 34,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                appName(
                  context: context,
                  fontSize: 18,
                  leadColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: IconButton(
              key: const ValueKey('main-profile-button'),
              tooltip: 'Open profile',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 52, height: 52),
              onPressed: () {
                context.pushNamed(AppRoute.profile.name);
              },
              icon: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.splashAccent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index),
      ),
    );
  }
}
