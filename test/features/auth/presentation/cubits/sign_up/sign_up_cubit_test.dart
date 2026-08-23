import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/features/auth/domain/entities/auth_credentials.dart';
import 'package:restropulse/src/features/auth/domain/entities/sign_up_result.dart';
import 'package:restropulse/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:restropulse/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/sign_up/sign_up_cubit.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/sign_up/sign_up_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late _FakeAuthRepository repository;

  setUp(() {
    repository = _FakeAuthRepository();
  });

  test('starts in the initial state', () {
    final cubit = SignUpCubit(SignUpUsecase(repository));

    expect(cubit.state, const SignUpState());

    cubit.close();
  });

  blocTest<SignUpCubit, SignUpState>(
    'emits loading then success and normalizes non-secret credentials',
    build: () {
      repository.signUpResult = const Right(
        SignUpResult(requiresEmailConfirmation: false),
      );
      return SignUpCubit(SignUpUsecase(repository));
    },
    act: (cubit) => cubit.signUp(
      fullName: '  Restaurant Owner  ',
      email: '  owner@example.com  ',
      password: ' password123 ',
    ),
    expect: () => const [
      SignUpState(
        status: SignUpStatus.loading,
        message: 'Creating your account...',
      ),
      SignUpState(
        status: SignUpStatus.success,
        message: 'Account created successfully.',
      ),
    ],
    verify: (_) {
      expect(repository.receivedCredentials?.fullName, 'Restaurant Owner');
      expect(repository.receivedCredentials?.email, 'owner@example.com');
      expect(repository.receivedCredentials?.password, ' password123 ');
    },
  );

  blocTest<SignUpCubit, SignUpState>(
    'reports when email confirmation is required',
    build: () {
      repository.signUpResult = const Right(
        SignUpResult(requiresEmailConfirmation: true),
      );
      return SignUpCubit(SignUpUsecase(repository));
    },
    act: (cubit) => cubit.signUp(
      fullName: 'Restaurant Owner',
      email: 'owner@example.com',
      password: 'password123',
    ),
    expect: () => const [
      SignUpState(
        status: SignUpStatus.loading,
        message: 'Creating your account...',
      ),
      SignUpState(
        status: SignUpStatus.success,
        message: 'Check your email to confirm your account.',
        requiresEmailConfirmation: true,
      ),
    ],
  );

  blocTest<SignUpCubit, SignUpState>(
    'emits loading then failure with the mapped failure message',
    build: () {
      repository.signUpResult = const Left(
        SupabaseFailure('An account already exists for this email.'),
      );
      return SignUpCubit(SignUpUsecase(repository));
    },
    act: (cubit) => cubit.signUp(
      fullName: 'Restaurant Owner',
      email: 'owner@example.com',
      password: 'password123',
    ),
    expect: () => const [
      SignUpState(
        status: SignUpStatus.loading,
        message: 'Creating your account...',
      ),
      SignUpState(
        status: SignUpStatus.failure,
        message: 'An account already exists for this email.',
      ),
    ],
  );
}

final class _FakeAuthRepository implements AuthRepository {
  Either<Failure, SignUpResult> signUpResult = const Right(
    SignUpResult(requiresEmailConfirmation: false),
  );
  AuthCredentials? receivedCredentials;

  @override
  Future<Either<Failure, SignUpResult>> signUpWithEmail(
    AuthCredentials credentials,
  ) async {
    receivedCredentials = credentials;
    return signUpResult;
  }

  @override
  Future<Either<Failure, AuthResponse>> signInWithEmail(
    AuthCredentials credentials,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signOut() {
    throw UnimplementedError();
  }
}
