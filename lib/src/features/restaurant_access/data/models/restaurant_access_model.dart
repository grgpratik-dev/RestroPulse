// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/restaurant_access.dart';

part 'restaurant_access_model.freezed.dart';
part 'restaurant_access_model.g.dart';

@freezed
abstract class RestaurantAccessModel with _$RestaurantAccessModel {
  const RestaurantAccessModel._();

  const factory RestaurantAccessModel({
    @JsonKey(name: 'restaurant_id') required String restaurantId,
    RestaurantRole? role,
    @JsonKey(name: 'status') String? requestStatus,
  }) = _RestaurantAccessModel;

  factory RestaurantAccessModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantAccessModelFromJson(json);

  RestaurantAccess toEntity() {
    if (role != null) {
      return RestaurantAccess(
        restaurantId: restaurantId,
        type: RestaurantAccessType.active,
        role: role,
      );
    }
    if (requestStatus == 'pending') {
      return RestaurantAccess(
        restaurantId: restaurantId,
        type: RestaurantAccessType.pending,
      );
    }
    throw const FormatException('Unknown restaurant access response.');
  }
}
