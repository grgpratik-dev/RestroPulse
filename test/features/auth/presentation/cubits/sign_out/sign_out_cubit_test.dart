import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/features/auth/domain/entities/auth_credentials.dart';
import 'package:restropulse/src/features/auth/domain/entities/sign_up_result.dart';
import 'package:restropulse/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:restropulse/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/sign_out/sign_out_cubit.dart';
import 'package:restropulse/src/features/auth/presentation/cubits/sign_out/sign_out_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late _FakeAuthRepository repository;

  setUp(() {
    repository = _FakeAuthRepository();
  });

  test('starts in the initial state', () {
    final cubit = SignOutCubit(SignOutUsecase(repository));

    expect(cubit.state, const SignOutState());

    cubit.close();
  });

  blocTest<SignOutCubit, SignOutState>(
    'emits loading then success',
    build: () => SignOutCubit(SignOutUsecase(repository)),
    act: (cubit) => cubit.signOut(),
    expect: () => const [
      SignOutState(status: SignOutStatus.loading),
      SignOutState(status: SignOutStatus.success),
    ],
  );

  blocTest<SignOutCubit, SignOutState>(
    'emits loading then failure with the mapped message',
    setUp: () {
      repository.signOutResult = const Left(
        SupabaseFailure('Could not log out.'),
      );
    },
    build: () => SignOutCubit(SignOutUsecase(repository)),
    act: (cubit) => cubit.signOut(),
    expect: () => const [
      SignOutState(status: SignOutStatus.loading),
      SignOutState(
        status: SignOutStatus.failure,
        message: 'Could not log out.',
      ),
    ],
  );
}

final class _FakeAuthRepository implements AuthRepository {
  Either<Failure, void> signOutResult = const Right(null);

  @override
  Future<Either<Failure, void>> signOut() async => signOutResult;

  @override
  Future<Either<Failure, AuthResponse>> signInWithEmail(
    AuthCredentials credentials,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, SignUpResult>> signUpWithEmail(
    AuthCredentials credentials,
  ) {
    throw UnimplementedError();
  }
}
