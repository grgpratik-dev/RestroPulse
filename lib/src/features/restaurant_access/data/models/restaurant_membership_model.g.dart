// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_membership_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RestaurantMembershipModel _$RestaurantMembershipModelFromJson(
  Map<String, dynamic> json,
) => _RestaurantMembershipModel(
  restaurantId: json['restaurant_id'] as String,
  role: $enumDecode(_$RestaurantRoleEnumMap, json['role']),
);

Map<String, dynamic> _$RestaurantMembershipModelToJson(
  _RestaurantMembershipModel instance,
) => <String, dynamic>{
  'restaurant_id': instance.restaurantId,
  'role': _$RestaurantRoleEnumMap[instance.role]!,
};

const _$RestaurantRoleEnumMap = {
  RestaurantRole.owner: 'owner',
  RestaurantRole.viewer: 'viewer',
};
