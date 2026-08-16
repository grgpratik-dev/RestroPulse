import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:restropulse/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:restropulse/src/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:restropulse/src/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:restropulse/src/features/expenses/domain/models/expense.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expense_categories_screen.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expense_category_details_screen.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expense_details_screen.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expense_form_screen.dart';
import 'package:restropulse/src/features/expenses/presentation/screens/expenses_screen.dart';
import 'package:restropulse/src/features/menu/domain/models/menu_item.dart';
import 'package:restropulse/src/features/menu/presentation/screens/menu_categories_screen.dart';
import 'package:restropulse/src/features/menu/presentation/screens/menu_item_details_screen.dart';
import 'package:restropulse/src/features/menu/presentation/screens/menu_item_form_screen.dart';
import 'package:restropulse/src/features/menu/presentation/screens/menu_screen.dart';
import 'package:restropulse/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:restropulse/src/features/profile/presentation/screen/help_and_support/help_and_support_screen.dart';
import 'package:restropulse/src/features/profile/presentation/screen/edit_restaurant_screen.dart';
import 'package:restropulse/src/features/profile/presentation/screen/change_password_screen.dart';
import 'package:restropulse/src/features/profile/presentation/screen/members_access_screen.dart';
import 'package:restropulse/src/features/profile/presentation/screen/personal_information_screen.dart';
import 'package:restropulse/src/features/profile/presentation/screen/profile_screen.dart';
import 'package:restropulse/src/features/reports/presentation/screen/reports_screen.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/screens/restaurant_access_screen.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/screens/create_restaurant_screen.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/screens/join_restaurant_screen.dart';
import 'package:restropulse/src/features/sales/domain/models/sales_order.dart';
import 'package:restropulse/src/features/sales/presentation/screens/order_details_screen.dart';
import 'package:restropulse/src/features/sales/presentation/screens/order_entry_screen.dart';
import 'package:restropulse/src/features/sales/presentation/screens/sales_history_screen.dart';
import 'package:restropulse/src/features/sales/presentation/screens/sales_screen.dart';
import 'package:restropulse/src/features/wastage/domain/models/wastage.dart';
import 'package:restropulse/src/features/wastage/presentation/screens/wastage_details_screen.dart';
import 'package:restropulse/src/features/wastage/presentation/screens/wastage_form_screen.dart';
import 'package:restropulse/src/features/wastage/presentation/screens/wastage_screen.dart';

import '../../features/auth/presentation/screens/register/register_screen.dart';
import '../../features/main/presentation/screens/main_screen.dart';
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
        path: AppRoute.forgotPassword.path,
        name: AppRoute.forgotPassword.name,
        builder: (context, state) =>
            ForgotPasswordScreen(initialEmail: state.extra as String?),
      ),
      GoRoute(
        path: AppRoute.resetPassword.path,
        name: AppRoute.resetPassword.name,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoute.register.path,
        name: AppRoute.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoute.restaurantAccess.path,
        name: AppRoute.restaurantAccess.name,
        builder: (context, state) => RestaurantAccessScreen(
          onCreateRestaurant: () =>
              context.pushNamed(AppRoute.createRestaurant.name),
          onJoinRestaurant: () =>
              context.pushNamed(AppRoute.joinRestaurant.name),
        ),
      ),
      GoRoute(
        path: AppRoute.createRestaurant.path,
        name: AppRoute.createRestaurant.name,
        builder: (context, state) => const CreateRestaurantScreen(),
      ),
      GoRoute(
        path: AppRoute.joinRestaurant.path,
        name: AppRoute.joinRestaurant.name,
        builder: (context, state) => const JoinRestaurantScreen(),
      ),

      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoute.editRestaurant.path,
        name: AppRoute.editRestaurant.name,
        builder: (context, state) => const EditRestaurantScreen(),
      ),
      GoRoute(
        path: AppRoute.personalInformation.path,
        name: AppRoute.personalInformation.name,
        builder: (context, state) => const PersonalInformationScreen(),
      ),
      GoRoute(
        path: AppRoute.changePassword.path,
        name: AppRoute.changePassword.name,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoute.membersAccess.path,
        name: AppRoute.membersAccess.name,
        builder: (context, state) => const MembersAccessScreen(),
      ),
      GoRoute(
        path: AppRoute.helpSupport.path,
        name: AppRoute.helpSupport.name,
        builder: (context, state) => const HelpAndSupportScreen(),
      ),
      GoRoute(
        path: AppRoute.addExpense.path,
        name: AppRoute.addExpense.name,
        builder: (context, state) =>
            ExpenseFormScreen(expense: state.extra as Expense?),
      ),
      GoRoute(
        path: AppRoute.expenseDetails.path,
        name: AppRoute.expenseDetails.name,
        builder: (context, state) => ExpenseDetailsScreen(
          expense: state.extra as Expense? ?? ExpensesMockData.expenses.first,
        ),
      ),
      GoRoute(
        path: AppRoute.expenseCategoryDetails.path,
        name: AppRoute.expenseCategoryDetails.name,
        builder: (context, state) {
          final data = state.extra as ExpenseCategoryDetailsData?;
          return ExpenseCategoryDetailsScreen(
            category:
                data?.category ??
                ExpensesMockData.categorySummaries(ExpensePeriod.month).first,
            period: data?.period ?? ExpensePeriod.month,
          );
        },
      ),
      GoRoute(
        path: AppRoute.expenseCategories.path,
        name: AppRoute.expenseCategories.name,
        builder: (context, state) => const ExpenseCategoriesScreen(),
      ),
      GoRoute(
        path: AppRoute.wastage.path,
        name: AppRoute.wastage.name,
        builder: (context, state) => const WastageScreen(),
      ),
      GoRoute(
        path: AppRoute.recordWastage.path,
        name: AppRoute.recordWastage.name,
        builder: (context, state) =>
            WastageFormScreen(entry: state.extra as WastageEntry?),
      ),
      GoRoute(
        path: AppRoute.wastageDetails.path,
        name: AppRoute.wastageDetails.name,
        builder: (context, state) => WastageDetailsScreen(
          entry: state.extra as WastageEntry? ?? WastageMockData.entries.first,
        ),
      ),
      GoRoute(
        path: AppRoute.addMenuItem.path,
        name: AppRoute.addMenuItem.name,
        builder: (context, state) =>
            MenuItemFormScreen(item: state.extra as MenuItem?),
      ),
      GoRoute(
        path: AppRoute.menuItemDetails.path,
        name: AppRoute.menuItemDetails.name,
        builder: (context, state) => MenuItemDetailsScreen(
          item: state.extra as MenuItem? ?? MenuMockData.items.first,
        ),
      ),
      GoRoute(
        path: AppRoute.menuCategories.path,
        name: AppRoute.menuCategories.name,
        builder: (context, state) => const MenuCategoriesScreen(),
      ),
      GoRoute(
        path: AppRoute.addOrder.path,
        name: AppRoute.addOrder.name,
        builder: (context, state) => const OrderEntryScreen(),
      ),
      GoRoute(
        path: AppRoute.batchEntry.path,
        name: AppRoute.batchEntry.name,
        builder: (context, state) => const OrderEntryScreen(isBatchMode: true),
      ),
      GoRoute(
        path: AppRoute.orderDetails.path,
        name: AppRoute.orderDetails.name,
        builder: (context, state) {
          final order = state.extra as SalesOrder?;
          return OrderDetailsScreen(
            order: order ?? SalesMockData.todayOrders.first,
          );
        },
      ),
      GoRoute(
        path: AppRoute.salesHistory.path,
        name: AppRoute.salesHistory.name,
        builder: (context, state) => const SalesHistoryScreen(),
      ),
    ],
  );
}
