final class JoinInvitation {
  const JoinInvitation({
    required this.restaurantId,
    required this.name,
    this.address,
  });
  final String restaurantId;
  final String name;
  final String? address;
}

final class AccessPerson {
  const AccessPerson({
    required this.id,
    required this.name,
    required this.role,
    this.email,
  });
  final String id;
  final String name;
  final String role;
  final String? email;
}

final class MembersAccess {
  const MembersAccess({
    required this.restaurantName,
    required this.isOwner,
    required this.members,
    required this.requests,
    this.joinCode,
    this.currencyCode,
  });
  final String restaurantName;
  final bool isOwner;
  final String? joinCode;
  final String? currencyCode;
  final List<AccessPerson> members;
  final List<AccessPerson> requests;
}
