import '../../domain/entities/restaurant_access.dart';
import 'restaurant_join_request_model.dart';
import 'restaurant_membership_model.dart';

sealed class RestaurantAccessModel {
  const RestaurantAccessModel();

  const factory RestaurantAccessModel.hasRestaurant({
    required RestaurantMembershipModel membership,
  }) = HasRestaurantAccessModel;

  const factory RestaurantAccessModel.pendingJoinRequest({
    required RestaurantJoinRequestModel request,
  }) = PendingJoinRequestAccessModel;

  const factory RestaurantAccessModel.noRestaurant() = NoRestaurantAccessModel;

  RestaurantAccess toEntity() => switch (this) {
    HasRestaurantAccessModel(:final membership) =>
      RestaurantAccess.hasRestaurant(membership: membership.toEntity()),
    PendingJoinRequestAccessModel(:final request) =>
      RestaurantAccess.pendingJoinRequest(request: request.toEntity()),
    NoRestaurantAccessModel() => const RestaurantAccess.noRestaurant(),
  };
}

final class HasRestaurantAccessModel extends RestaurantAccessModel {
  const HasRestaurantAccessModel({required this.membership});

  final RestaurantMembershipModel membership;
}

final class PendingJoinRequestAccessModel extends RestaurantAccessModel {
  const PendingJoinRequestAccessModel({required this.request});

  final RestaurantJoinRequestModel request;
}

final class NoRestaurantAccessModel extends RestaurantAccessModel {
  const NoRestaurantAccessModel();
}
