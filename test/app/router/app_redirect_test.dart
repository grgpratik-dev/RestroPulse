import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/app/router/app_redirect.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/core/enums/enums.dart';

void main() {
  test('users without a restaurant can complete every setup step', () {
    for (final route in [
      AppRoute.restaurantAccess,
      AppRoute.chooseCountry,
      AppRoute.createRestaurant,
      AppRoute.joinRestaurant,
    ]) {
      expect(appRedirect(AppStatus.noRestaurantAccess, route.path), isNull);
    }
  });

  test(
    'country selection remains protected by authentication and access checks',
    () {
      final expected = {
        AppStatus.initializing: AppRoute.splash,
        AppStatus.checkingRestaurantAccess: AppRoute.splash,
        AppStatus.onboarding: AppRoute.onboarding,
        AppStatus.unauthenticated: AppRoute.auth,
        AppStatus.restaurantAccessPending: AppRoute.restaurantAccess,
        AppStatus.restaurantAccessFailure: AppRoute.restaurantAccess,
        AppStatus.hasRestaurantAccess: AppRoute.dashboard,
      };
      for (final entry in expected.entries) {
        expect(
          appRedirect(entry.key, AppRoute.chooseCountry.path),
          entry.value.path,
        );
      }
    },
  );

  test(
    'users without restaurant access cannot bypass setup to the dashboard',
    () {
      expect(
        appRedirect(AppStatus.noRestaurantAccess, AppRoute.dashboard.path),
        AppRoute.restaurantAccess.path,
      );
    },
  );
}
