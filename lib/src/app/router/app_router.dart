import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:restropulse/src/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:restropulse/src/features/menu/presentation/screens/menu_screen.dart';
import 'package:restropulse/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:restropulse/src/features/profile/presentation/screen/profile_screen.dart';
import 'package:restropulse/src/features/reports/presentation/screen/reports_screen.dart';
import 'package:restropulse/src/features/sales/presentation/screens/sales_screen.dart';

import '../../features/auth/presentation/screens/register/register_screen.dart';
import '../../features/main/presentation/screens/main_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static final GoRouter goRouter = GoRouter(
    debugLogDiagnostics: kDebugMode,
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoute.dashboard.path,
    routes: [
      // Define your app routes here
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.dashboard.path,
                name: AppRoute.dashboard.name,
                builder: (context, state) => DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.sales.path,
                name: AppRoute.sales.name,
                builder: (context, state) => SalesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.expenses.path,
                name: AppRoute.expenses.name,
                builder: (context, state) => ExpensesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.menu.path,
                name: AppRoute.menu.name,
                builder: (context, state) => MenuScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.reports.path,
                name: AppRoute.reports.name,
                builder: (context, state) => ReportsScreen(),
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
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.register.path,
        name: AppRoute.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
