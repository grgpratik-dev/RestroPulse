// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_management_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JoinInvitationModel _$JoinInvitationModelFromJson(Map<String, dynamic> json) =>
    _JoinInvitationModel(
      restaurantId: json['restaurant_id'] as String,
      name: json['restaurant_name'] as String,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$JoinInvitationModelToJson(
  _JoinInvitationModel instance,
) => <String, dynamic>{
  'restaurant_id': instance.restaurantId,
  'restaurant_name': instance.name,
  'address': instance.address,
};

_AccessPersonModel _$AccessPersonModelFromJson(Map<String, dynamic> json) =>
    _AccessPersonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AccessPersonModelToJson(_AccessPersonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'email': instance.email,
    };

_MembersAccessModel _$MembersAccessModelFromJson(Map<String, dynamic> json) =>
    _MembersAccessModel(
      restaurantName: json['restaurant_name'] as String,
      isOwner: json['is_owner'] as bool,
      joinCode: json['join_code'] as String?,
      currencyCode: json['currency_code'] as String?,
      members: (json['members'] as List<dynamic>)
          .map((e) => AccessPersonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      requests: (json['requests'] as List<dynamic>)
          .map((e) => AccessPersonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MembersAccessModelToJson(_MembersAccessModel instance) =>
    <String, dynamic>{
      'restaurant_name': instance.restaurantName,
      'is_owner': instance.isOwner,
      'join_code': instance.joinCode,
      'currency_code': instance.currencyCode,
      'members': instance.members,
      'requests': instance.requests,
    };
