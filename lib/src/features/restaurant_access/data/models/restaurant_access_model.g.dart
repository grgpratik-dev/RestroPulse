// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_access_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RestaurantAccessModel _$RestaurantAccessModelFromJson(
  Map<String, dynamic> json,
) => _RestaurantAccessModel(
  restaurantId: json['restaurant_id'] as String,
  role: $enumDecodeNullable(_$RestaurantRoleEnumMap, json['role']),
  requestStatus: json['status'] as String?,
);

Map<String, dynamic> _$RestaurantAccessModelToJson(
  _RestaurantAccessModel instance,
) => <String, dynamic>{
  'restaurant_id': instance.restaurantId,
  'role': _$RestaurantRoleEnumMap[instance.role],
  'status': instance.requestStatus,
};

const _$RestaurantRoleEnumMap = {
  RestaurantRole.owner: 'owner',
  RestaurantRole.viewer: 'viewer',
};
