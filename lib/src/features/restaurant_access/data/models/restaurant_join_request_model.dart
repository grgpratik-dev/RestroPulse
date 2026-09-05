// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/restaurant_access.dart';

part 'restaurant_join_request_model.freezed.dart';
part 'restaurant_join_request_model.g.dart';

@freezed
abstract class RestaurantJoinRequestModel with _$RestaurantJoinRequestModel {
  const RestaurantJoinRequestModel._();

  const factory RestaurantJoinRequestModel({
    required String id,
    @JsonKey(name: 'restaurant_id') required String restaurantId,
    @JsonKey(name: 'requester_profile_id') String? requesterProfileId,
    required String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _RestaurantJoinRequestModel;

  factory RestaurantJoinRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantJoinRequestModelFromJson(json);

  RestaurantJoinRequest toEntity() => RestaurantJoinRequest(
    id: id,
    restaurantId: restaurantId,
    requesterProfileId: requesterProfileId,
    status: status,
    createdAt: createdAt,
  );
}
