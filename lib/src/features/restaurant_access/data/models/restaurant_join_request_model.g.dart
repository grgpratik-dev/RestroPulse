// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_join_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RestaurantJoinRequestModel _$RestaurantJoinRequestModelFromJson(
  Map<String, dynamic> json,
) => _RestaurantJoinRequestModel(
  id: json['id'] as String,
  restaurantId: json['restaurant_id'] as String,
  requesterProfileId: json['requester_profile_id'] as String?,
  status: json['status'] as String,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$RestaurantJoinRequestModelToJson(
  _RestaurantJoinRequestModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'restaurant_id': instance.restaurantId,
  'requester_profile_id': instance.requesterProfileId,
  'status': instance.status,
  'created_at': instance.createdAt?.toIso8601String(),
};
