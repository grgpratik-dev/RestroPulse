import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/features/main/presentation/screens/screen1.dart';
import 'package:restropulse/src/features/onboarding/presentation/screens/onboarding_screen.dart';

import '../../features/main/presentation/screens/main_screen.dart';
import '../../features/main/presentation/screens/screen2.dart';
import '../../features/main/presentation/screens/screen3.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static final GoRouter goRouter = GoRouter(
    debugLogDiagnostics: kDebugMode,
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoute.splash.path,
    routes: [
      // Define your app routes here
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.screen1.path,
                name: AppRoute.screen1.name,
                builder: (context, state) => Screen1(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.screen2.path,
                name: AppRoute.screen2.name,
                builder: (context, state) => Screen2(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.screen3.path,
                name: AppRoute.screen3.name,
                builder: (context, state) => Screen3(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      
      GoRoute(
        path: AppRoute.onboarding.path,
        name: AppRoute.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
}
