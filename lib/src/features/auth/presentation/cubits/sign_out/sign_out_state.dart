import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_out_state.freezed.dart';

enum SignOutStatus { initial, loading, success, failure }

@freezed
abstract class SignOutState with _$SignOutState {
  const factory SignOutState({
    @Default(SignOutStatus.initial) SignOutStatus status,
    String? message,
  }) = _SignOutState;
}
