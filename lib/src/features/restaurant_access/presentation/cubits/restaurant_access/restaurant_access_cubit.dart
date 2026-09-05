import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/core/usecase/usecase.dart';
import 'package:restropulse/src/features/restaurant_access/domain/entities/restaurant_access.dart';
import 'package:restropulse/src/features/restaurant_access/domain/usecases/get_current_restaurant_access_usecase.dart';

part 'restaurant_access_cubit.freezed.dart';
part 'restaurant_access_state.dart';

final class RestaurantAccessCubit extends Cubit<RestaurantAccessState> {
  RestaurantAccessCubit(this._getCurrentRestaurantAccess)
    : super(const RestaurantAccessState.initial());

  final GetCurrentRestaurantAccessUsecase _getCurrentRestaurantAccess;

  Future<void>? _inFlightOperation;

  /// Loads restaurant access with full loading state.
  /// Used during initial startup / setup checks.
  Future<void> loadRestaurantAccess() => _fetchAccess(showLoading: true);

  /// Refreshes restaurant access.
  /// By default, [showLoading] is false to avoid flashing full-screen loading
  /// during background refreshes (e.g. after creating/joining or periodic checks).
  Future<void> refreshRestaurantAccess({bool showLoading = false}) =>
      _fetchAccess(showLoading: showLoading);

  /// Resets state back to initial and clears any in-flight requests.
  /// Prevents stale restaurant data from persisting after user logout.
  void reset() {
    _inFlightOperation = null;
    emit(const RestaurantAccessState.initial());
  }

  Future<void> _fetchAccess({required bool showLoading}) async {
    if (_inFlightOperation != null) {
      return _inFlightOperation;
    }

    final operation = _performFetch(showLoading: showLoading);
    _inFlightOperation = operation;

    try {
      await operation;
    } finally {
      _inFlightOperation = null;
    }
  }

  Future<void> _performFetch({required bool showLoading}) async {
    if (showLoading) {
      emit(const RestaurantAccessState.loading());
    }

    final result = await _getCurrentRestaurantAccess(NoParams());
    if (isClosed) return;

    result.fold(
      (failure) => emit(RestaurantAccessState.failure(failure: failure)),
      (access) {
        emit(switch (access) {
          HasRestaurantAccess(:final membership) =>
            RestaurantAccessState.hasRestaurant(
              restaurantId: membership.restaurantId,
              role: membership.role,
            ),
          PendingJoinRequestAccess(:final request) =>
            RestaurantAccessState.pendingJoinRequest(request: request),
          NoRestaurantAccess() => const RestaurantAccessState.noRestaurant(),
        });
      },
    );
  }
}
