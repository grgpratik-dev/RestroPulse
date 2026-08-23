part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  requestingOtp,
  otpSent,
  otpRequestFailure,
  verifyingOtp,
  otpVerified,
  otpVerificationFailure,
}

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    String? email,
    String? message,
  }) = _AuthState;


}
