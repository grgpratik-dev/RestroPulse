import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/core/usecase/usecase.dart';
import 'package:restropulse/src/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:restropulse/src/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:restropulse/src/features/auth/domain/usecases/verify_otp_params.dart';
import 'package:restropulse/src/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._requestOtpUsecase,
    this._verifyOtpUsecase,
    this._signInWithGoogleUsecase,
  ) : super(const AuthState());

  final RequestOtpUsecase _requestOtpUsecase;
  final VerifyOtpUsecase _verifyOtpUsecase;
  final SignInWithGoogleUsecase _signInWithGoogleUsecase;

  Future<void> signInWithGoogle() async {
    if (state.status == AuthStatus.googleSignInInProgress) return;

    emit(const AuthState(status: AuthStatus.googleSignInInProgress));

    final result = await _signInWithGoogleUsecase(NoParams());
    if (isClosed) return;

    result.fold((failure) {
      if (failure is AuthCancelledFailure) {
        emit(const AuthState(status: AuthStatus.googleSignInCancelled));
        return;
      }

      emit(
        AuthState(
          status: AuthStatus.googleSignInFailure,
          message: failure.message,
        ),
      );
    }, (_) => emit(const AuthState(status: AuthStatus.googleSignInSuccess)));
  }

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
