import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/core/usecase/usecase.dart';
import 'package:restropulse/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:restropulse/src/features/auth/domain/usecases/verify_otp_params.dart';

final class VerifyOtpUsecase extends UseCase<void, VerifyOtpParams> {
  VerifyOtpUsecase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(params.email, params.token);
  }
}
