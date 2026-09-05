import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/access_management.dart';
import '../../../domain/repositories/access_management_repository.dart';
part 'join_restaurant_cubit.freezed.dart';

@freezed
abstract class JoinRestaurantState with _$JoinRestaurantState {
  const factory JoinRestaurantState({
    @Default(false) bool loading,
    @Default(false) bool requestSent,
    @Default('') String code,
    JoinInvitation? invitation,
    String? message,
  }) = _JoinRestaurantState;
}

final class JoinRestaurantCubit extends Cubit<JoinRestaurantState> {
  JoinRestaurantCubit(this._repository) : super(const JoinRestaurantState());
  final AccessManagementRepository _repository;
  int _lookupVersion = 0;

  void codeChanged(String code) {
    if (state.requestSent || (state.loading && state.invitation != null)) {
      return;
    }
    _lookupVersion++;
    emit(JoinRestaurantState(code: code.trim().toUpperCase()));
  }

  Future<void> lookup() async {
    if (state.loading || state.requestSent) return;
    if (state.code.isEmpty) {
      emit(state.copyWith(message: 'Enter your invitation code.'));
      return;
    }
    final version = ++_lookupVersion;
    emit(state.copyWith(loading: true, invitation: null, message: null));
    final result = await _repository.resolveCode(state.code);
    if (isClosed || version != _lookupVersion) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(loading: false, message: failure.message)),
      (invitation) =>
          emit(state.copyWith(loading: false, invitation: invitation)),
    );
  }

  Future<void> request() async {
    if (state.loading || state.requestSent || state.invitation == null) return;
    emit(state.copyWith(loading: true, message: null));
    final result = await _repository.requestJoin(state.code);
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(loading: false, message: failure.message)),
      (_) => emit(state.copyWith(loading: false, requestSent: true)),
    );
  }
}
