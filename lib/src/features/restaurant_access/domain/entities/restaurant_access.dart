enum RestaurantRole { owner, viewer }

enum RestaurantAccessType { active, pending }

final class RestaurantAccess {
  const RestaurantAccess({
    required this.restaurantId,
    required this.type,
    this.role,
  });

  final String restaurantId;
  final RestaurantAccessType type;
  final RestaurantRole? role;

  bool get isActive => type == RestaurantAccessType.active;
  bool get isPending => type == RestaurantAccessType.pending;
  bool get isOwner => role == RestaurantRole.owner;
}
