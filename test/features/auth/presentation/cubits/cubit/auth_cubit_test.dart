import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:restropulse/src/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:restropulse/src/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:restropulse/src/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/auth/auth_cubit.dart';

void main() {
  late _FakeAuthRepository repository;

  setUp(() {
    repository = _FakeAuthRepository();
  });

  AuthCubit buildCubit() => AuthCubit(
    RequestOtpUsecase(repository),
    VerifyOtpUsecase(repository),
    SignInWithGoogleUsecase(repository),
  );

  blocTest<AuthCubit, AuthState>(
    'sends an OTP and remembers the normalized email',
    build: buildCubit,
    act: (cubit) => cubit.requestOtp('  owner@restropulse.com  '),
    expect: () => const [
      AuthState(
        status: AuthStatus.requestingOtp,
        email: 'owner@restropulse.com',
      ),
      AuthState(status: AuthStatus.otpSent, email: 'owner@restropulse.com'),
    ],
    verify: (_) => expect(repository.email, 'owner@restropulse.com'),
  );

  blocTest<AuthCubit, AuthState>(
    'verifies the OTP',
    build: buildCubit,
    act: (cubit) =>
        cubit.verifyOtp(email: 'owner@restropulse.com', token: ' 123456 '),
    expect: () => const [
      AuthState(
        status: AuthStatus.verifyingOtp,
        email: 'owner@restropulse.com',
      ),
      AuthState(status: AuthStatus.otpVerified, email: 'owner@restropulse.com'),
    ],
    verify: (_) {
      expect(repository.email, 'owner@restropulse.com');
      expect(repository.token, '123456');
    },
  );

  blocTest<AuthCubit, AuthState>(
    'exposes OTP request failures',
    setUp: () {
      repository.signInResult = const Left(
        SupabaseFailure('Unable to send the code.'),
      );
    },
    build: buildCubit,
    act: (cubit) => cubit.requestOtp('owner@restropulse.com'),
    expect: () => const [
      AuthState(
        status: AuthStatus.requestingOtp,
        email: 'owner@restropulse.com',
      ),
      AuthState(
        status: AuthStatus.otpRequestFailure,
        email: 'owner@restropulse.com',
        message: 'Unable to send the code.',
      ),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'exposes OTP verification failures',
    setUp: () {
      repository.verifyResult = const Left(
        SupabaseFailure('The code is invalid or expired.'),
      );
    },
    build: buildCubit,
    act: (cubit) =>
        cubit.verifyOtp(email: 'owner@restropulse.com', token: '123456'),
    expect: () => const [
      AuthState(
        status: AuthStatus.verifyingOtp,
        email: 'owner@restropulse.com',
      ),
      AuthState(
        status: AuthStatus.otpVerificationFailure,
        email: 'owner@restropulse.com',
        message: 'The code is invalid or expired.',
      ),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'signs in with Google',
    build: buildCubit,
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => const [
      AuthState(status: AuthStatus.googleSignInInProgress),
      AuthState(status: AuthStatus.googleSignInSuccess),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'exposes Google sign-in failures',
    setUp: () {
      repository.googleSignInResult = const Left(
        GoogleSignInFailure(
          'Google sign-in is currently unavailable.',
          googleCode: 'providerConfigurationError',
        ),
      );
    },
    build: buildCubit,
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => const [
      AuthState(status: AuthStatus.googleSignInInProgress),
      AuthState(
        status: AuthStatus.googleSignInFailure,
        message: 'Google sign-in is currently unavailable.',
      ),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'treats closing the Google picker as cancellation',
    setUp: () {
      repository.googleSignInResult = const Left(AuthCancelledFailure());
    },
    build: buildCubit,
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => const [
      AuthState(status: AuthStatus.googleSignInInProgress),
      AuthState(status: AuthStatus.googleSignInCancelled),
    ],
  );
}

final class _FakeAuthRepository implements AuthRepository {
  Either<Failure, void> signInResult = const Right(null);
  Either<Failure, void> verifyResult = const Right(null);
  Either<Failure, void> googleSignInResult = const Right(null);

  String? email;
  String? token;

  @override
  Future<Either<Failure, void>> requestOtp(String email) async {
    this.email = email;
    return signInResult;
  }

  @override
  Future<Either<Failure, void>> signInWithGoogle() async {
    return googleSignInResult;
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String email, String token) async {
    this.email = email;
    this.token = token;
    return verifyResult;
  }

  @override
  Future<Either<Failure, void>> signOut() async => const Right(null);
}
