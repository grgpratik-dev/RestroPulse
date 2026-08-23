import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/features/auth/domain/entities/auth_credentials.dart';
import 'package:restropulse/src/features/auth/domain/entities/sign_up_result.dart';
import 'package:restropulse/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:restropulse/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/sign_in/sign_in_cubit.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/sign_in/sign_in_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late _FakeAuthRepository repository;

  setUp(() {
    repository = _FakeAuthRepository();
  });

  test('starts in the initial state', () {
    final cubit = SignInCubit(SignInUsecase(repository));

    expect(cubit.state, const SignInState());

    cubit.close();
  });

  blocTest<SignInCubit, SignInState>(
    'emits loading then success and trims the email',
    build: () {
      repository.signInResult = Right(AuthResponse());
      return SignInCubit(SignInUsecase(repository));
    },
    act: (cubit) =>
        cubit.signIn(email: '  owner@example.com  ', password: 'password123'),
    expect: () => const [
      SignInState(status: SignInStatus.loading, message: 'Signing in...'),
      SignInState(status: SignInStatus.success, message: 'Sign in successful'),
    ],
    verify: (_) {
      expect(repository.receivedCredentials?.email, 'owner@example.com');
      expect(repository.receivedCredentials?.password, 'password123');
    },
  );

  blocTest<SignInCubit, SignInState>(
    'emits loading then failure with the mapped failure message',
    build: () {
      repository.signInResult = const Left(
        SupabaseFailure('The email or password is incorrect.'),
      );
      return SignInCubit(SignInUsecase(repository));
    },
    act: (cubit) =>
        cubit.signIn(email: 'owner@example.com', password: 'wrong-password'),
    expect: () => const [
      SignInState(status: SignInStatus.loading, message: 'Signing in...'),
      SignInState(
        status: SignInStatus.failure,
        message: 'The email or password is incorrect.',
      ),
    ],
  );
}

final class _FakeAuthRepository implements AuthRepository {
  Either<Failure, AuthResponse> signInResult = Right(AuthResponse());
  AuthCredentials? receivedCredentials;

  @override
  Future<Either<Failure, AuthResponse>> signInWithEmail(
    AuthCredentials credentials,
  ) async {
    receivedCredentials = credentials;
    return signInResult;
  }

  @override
  Future<Either<Failure, void>> signOut() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SignUpResult>> signUpWithEmail(
    AuthCredentials credentials,
  ) {
    throw UnimplementedError();
  }
}
