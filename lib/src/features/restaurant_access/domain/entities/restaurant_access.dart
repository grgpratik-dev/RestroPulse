enum RestaurantRole { owner, viewer }

enum RestaurantAccessStatus { noRestaurant, pendingJoinRequest, hasRestaurant }

enum RestaurantAccessType { active, pending }

final class RestaurantMembership {
  const RestaurantMembership({required this.restaurantId, required this.role});

  final String restaurantId;
  final RestaurantRole role;
}

final class RestaurantJoinRequest {
  const RestaurantJoinRequest({
    required this.id,
    required this.restaurantId,
    this.requesterProfileId,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String restaurantId;
  final String? requesterProfileId;
  final String status;
  final DateTime? createdAt;
}

sealed class RestaurantAccess {
  const RestaurantAccess();

  const factory RestaurantAccess.hasRestaurant({
    required RestaurantMembership membership,
  }) = HasRestaurantAccess;

  const factory RestaurantAccess.pendingJoinRequest({
    required RestaurantJoinRequest request,
  }) = PendingJoinRequestAccess;

  const factory RestaurantAccess.noRestaurant() = NoRestaurantAccess;

  RestaurantAccessStatus get status;

  bool get hasRestaurant => status == RestaurantAccessStatus.hasRestaurant;
  bool get isPending => status == RestaurantAccessStatus.pendingJoinRequest;
  bool get isNoRestaurant => status == RestaurantAccessStatus.noRestaurant;

  RestaurantAccessType? get type => switch (this) {
    HasRestaurantAccess() => RestaurantAccessType.active,
    PendingJoinRequestAccess() => RestaurantAccessType.pending,
    NoRestaurantAccess() => null,
  };

  String? get restaurantId => switch (this) {
    HasRestaurantAccess(:final membership) => membership.restaurantId,
    PendingJoinRequestAccess(:final request) => request.restaurantId,
    NoRestaurantAccess() => null,
  };

  RestaurantRole? get role => switch (this) {
    HasRestaurantAccess(:final membership) => membership.role,
    _ => null,
  };

  bool get isActive => type == RestaurantAccessType.active;
  bool get isOwner => role == RestaurantRole.owner;
}

final class HasRestaurantAccess extends RestaurantAccess {
  const HasRestaurantAccess({required this.membership});

  final RestaurantMembership membership;

  @override
  RestaurantAccessStatus get status => RestaurantAccessStatus.hasRestaurant;
}

final class PendingJoinRequestAccess extends RestaurantAccess {
  const PendingJoinRequestAccess({required this.request});

  final RestaurantJoinRequest request;

  @override
  RestaurantAccessStatus get status =>
      RestaurantAccessStatus.pendingJoinRequest;

  String get requestId => request.id;
  DateTime? get createdAt => request.createdAt;
}

final class NoRestaurantAccess extends RestaurantAccess {
  const NoRestaurantAccess();

  @override
  RestaurantAccessStatus get status => RestaurantAccessStatus.noRestaurant;
}
