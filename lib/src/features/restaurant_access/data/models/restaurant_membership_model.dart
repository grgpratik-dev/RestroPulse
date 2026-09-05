// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/restaurant_access.dart';

part 'restaurant_membership_model.freezed.dart';
part 'restaurant_membership_model.g.dart';

@freezed
abstract class RestaurantMembershipModel with _$RestaurantMembershipModel {
  const RestaurantMembershipModel._();

  const factory RestaurantMembershipModel({
    @JsonKey(name: 'restaurant_id') required String restaurantId,
    required RestaurantRole role,
  }) = _RestaurantMembershipModel;

  factory RestaurantMembershipModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantMembershipModelFromJson(json);

  RestaurantMembership toEntity() =>
      RestaurantMembership(restaurantId: restaurantId, role: role);
}
