// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/access_management.dart';
part 'access_management_model.freezed.dart';
part 'access_management_model.g.dart';

@freezed
abstract class JoinInvitationModel with _$JoinInvitationModel {
  const JoinInvitationModel._();
  const factory JoinInvitationModel({
    @JsonKey(name: 'restaurant_id') required String restaurantId,
    @JsonKey(name: 'restaurant_name') required String name,
    String? address,
  }) = _JoinInvitationModel;
  factory JoinInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$JoinInvitationModelFromJson(json);
  JoinInvitation toEntity() =>
      JoinInvitation(restaurantId: restaurantId, name: name, address: address);
}

@freezed
abstract class AccessPersonModel with _$AccessPersonModel {
  const AccessPersonModel._();
  const factory AccessPersonModel({
    required String id,
    required String name,
    required String role,
    String? email,
  }) = _AccessPersonModel;
  factory AccessPersonModel.fromJson(Map<String, dynamic> json) =>
      _$AccessPersonModelFromJson(json);
  AccessPerson toEntity() =>
      AccessPerson(id: id, name: name, role: role, email: email);
}

@freezed
abstract class MembersAccessModel with _$MembersAccessModel {
  const MembersAccessModel._();
  const factory MembersAccessModel({
    @JsonKey(name: 'restaurant_name') required String restaurantName,
    @JsonKey(name: 'is_owner') required bool isOwner,
    @JsonKey(name: 'join_code') String? joinCode,
    @JsonKey(name: 'currency_code') String? currencyCode,
    required List<AccessPersonModel> members,
    required List<AccessPersonModel> requests,
  }) = _MembersAccessModel;
  factory MembersAccessModel.fromJson(Map<String, dynamic> json) =>
      _$MembersAccessModelFromJson(json);
  MembersAccess toEntity() => MembersAccess(
    restaurantName: restaurantName,
    isOwner: isOwner,
    joinCode: joinCode,
    currencyCode: currencyCode,
    members: List.unmodifiable(members.map((item) => item.toEntity())),
    requests: List.unmodifiable(requests.map((item) => item.toEntity())),
  );
}
