import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/country.dart';
import '../../../domain/repositories/create_restaurant_repository.dart';
part 'create_restaurant_cubit.freezed.dart';

@freezed
abstract class CreateRestaurantState with _$CreateRestaurantState {
  const factory CreateRestaurantState({
    @Default(false) bool loading,
    @Default(false) bool success,
    String? restaurantId,
    String? message,
  }) = _CreateRestaurantState;
}

final class CreateRestaurantCubit extends Cubit<CreateRestaurantState> {
  CreateRestaurantCubit(this._repository)
    : super(const CreateRestaurantState());
  final CreateRestaurantRepository _repository;

  Future<void> submit({
    required Country country,
    required String name,
    required String address,
    required String phone,
    Uint8List? logo,
  }) async {
    if (state.loading || state.success) return;
    final currency =
        country.defaultCurrencyCode ?? country.currencyCodes.firstOrNull;
    if (currency == null) {
      emit(
        state.copyWith(
          message: 'Please choose a country with a supported currency.',
        ),
      );
      return;
    }
    emit(state.copyWith(loading: true, message: null));
    var id = state.restaurantId;
    if (id == null) {
      final result = await _repository.create(
        name: name,
        countryCode: country.code,
        currencyCode: currency,
        address: address,
        phone: phone,
      );
      if (isClosed) return;
      result.fold(
        (failure) =>
            emit(state.copyWith(loading: false, message: failure.message)),
        (value) => id = value,
      );
      if (id == null) return;
      emit(state.copyWith(restaurantId: id));
    }
    if (logo != null) {
      final result = await _repository.uploadLogo(id!, logo);
      if (isClosed) return;
      if (result.isLeft()) {
        result.fold(
          (failure) =>
              emit(state.copyWith(loading: false, message: failure.message)),
          (_) {},
        );
        return;
      }
    }
    emit(state.copyWith(loading: false, success: true));
  }

  void continueWithoutLogo() {
    if (!state.loading && state.restaurantId != null) {
      emit(state.copyWith(success: true, message: null));
    }
  }
}
