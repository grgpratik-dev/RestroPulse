import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/core/usecase/usecase.dart';
import 'package:restropulse/src/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogleUsecase extends UseCase<void, NoParams> {
  SignInWithGoogleUsecase(this._authRepository);

  final AuthRepository _authRepository;
  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _authRepository.signInWithGoogle();
  }
}
