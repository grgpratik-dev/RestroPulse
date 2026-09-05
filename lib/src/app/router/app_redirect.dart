import 'package:restropulse/src/core/enums/enums.dart';

import 'app_route.dart';

String? appRedirect(AppStatus status, String location) {
  final publicRoutes = {AppRoute.auth.path, AppRoute.verifyOTP.path};
  final restaurantSetupRoutes = {
    AppRoute.restaurantAccess.path,
    AppRoute.chooseCountry.path,
    AppRoute.createRestaurant.path,
    AppRoute.joinRestaurant.path,
  };

  final entryRoutes = {
    AppRoute.splash.path,
    AppRoute.onboarding.path,
    AppRoute.auth.path,
    AppRoute.verifyOTP.path,
  };
  switch (status) {
    case AppStatus.initializing:
    case AppStatus.checkingRestaurantAccess:
      if (location != AppRoute.splash.path) {
        return AppRoute.splash.path;
      }

      return null;

    case AppStatus.onboarding:
      if (location != AppRoute.onboarding.path) {
        return AppRoute.onboarding.path;
      }

      return null;

    case AppStatus.unauthenticated:
      if (publicRoutes.contains(location)) {
        return null;
      }
      return AppRoute.auth.path;

    case AppStatus.noRestaurantAccess:
      if (restaurantSetupRoutes.contains(location)) {
        return null;
      }
      return AppRoute.restaurantAccess.path;

    case AppStatus.restaurantAccessPending:
    case AppStatus.restaurantAccessFailure:
      if (location == AppRoute.restaurantAccess.path) {
        return null;
      }
      return AppRoute.restaurantAccess.path;

    case AppStatus.hasRestaurantAccess:
      if (entryRoutes.contains(location) ||
          restaurantSetupRoutes.contains(location)) {
        return AppRoute.dashboard.path;
      }
      return null;
  }
}
