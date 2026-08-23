import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restropulse/src/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:restropulse/src/features/auth/domain/usecases/verify_otp_params.dart';
import 'package:restropulse/src/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._requestOtpUsecase, this._verifyOtpUsecase)
    : super(const AuthState());

  final RequestOtpUsecase _requestOtpUsecase;
  final VerifyOtpUsecase _verifyOtpUsecase;

  Future<void> requestOtp(String email) async {
    final normalizedEmail = email.trim();
    emit(AuthState(status: AuthStatus.requestingOtp, email: normalizedEmail));

    final result = await _requestOtpUsecase(normalizedEmail);

    result.fold(
      (failure) => emit(
        AuthState(
          status: AuthStatus.otpRequestFailure,
          email: normalizedEmail,
          message: failure.message,
        ),
      ),
      (_) =>
          emit(AuthState(status: AuthStatus.otpSent, email: normalizedEmail)),
    );
  }

  Future<void> verifyOtp({required String email, required String token}) async {
    final normalizedEmail = email.trim();
    emit(AuthState(status: AuthStatus.verifyingOtp, email: normalizedEmail));

    final result = await _verifyOtpUsecase(
      VerifyOtpParams(email: normalizedEmail, token: token.trim()),
    );

    result.fold(
      (failure) => emit(
        AuthState(
          status: AuthStatus.otpVerificationFailure,
          email: normalizedEmail,
          message: failure.message,
        ),
      ),
      (_) => emit(
        AuthState(status: AuthStatus.otpVerified, email: normalizedEmail),
      ),
    );
  }
}
