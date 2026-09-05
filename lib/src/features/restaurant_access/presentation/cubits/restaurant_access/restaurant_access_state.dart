part of 'restaurant_access_cubit.dart';

@freezed
sealed class RestaurantAccessState with _$RestaurantAccessState {
  const RestaurantAccessState._();

  const factory RestaurantAccessState.initial() = RestaurantAccessInitial;

  const factory RestaurantAccessState.loading() = RestaurantAccessLoading;

  const factory RestaurantAccessState.noRestaurant() =
      RestaurantAccessNoRestaurant;

  const factory RestaurantAccessState.pendingJoinRequest({
    required RestaurantJoinRequest request,
  }) = RestaurantAccessPendingJoinRequest;

  const factory RestaurantAccessState.hasRestaurant({
    required String restaurantId,
    required RestaurantRole role,
  }) = RestaurantAccessHasRestaurant;

  const factory RestaurantAccessState.failure({required Failure failure}) =
      RestaurantAccessFailure;

  bool get isInitial => this is RestaurantAccessInitial;
  bool get isLoading => this is RestaurantAccessLoading;
  bool get isNoRestaurant => this is RestaurantAccessNoRestaurant;
  bool get isPendingJoinRequest => this is RestaurantAccessPendingJoinRequest;
  bool get hasRestaurant => this is RestaurantAccessHasRestaurant;
  bool get isFailure => this is RestaurantAccessFailure;

  String? get restaurantId => switch (this) {
    RestaurantAccessHasRestaurant(:final restaurantId) => restaurantId,
    RestaurantAccessPendingJoinRequest(:final request) => request.restaurantId,
    _ => null,
  };

  RestaurantRole? get role => switch (this) {
    RestaurantAccessHasRestaurant(:final role) => role,
    _ => null,
  };

  RestaurantJoinRequest? get pendingRequest => switch (this) {
    RestaurantAccessPendingJoinRequest(:final request) => request,
    _ => null,
  };

  Failure? get failureOrNull => switch (this) {
    RestaurantAccessFailure(:final failure) => failure,
    _ => null,
  };
}
