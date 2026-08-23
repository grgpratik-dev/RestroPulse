import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/core/usecase/usecase.dart';
import 'package:restropulse/src/features/auth/domain/repositories/auth_repository.dart';

final class RequestOtpUsecase extends UseCase<void, String> {
  RequestOtpUsecase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(String email) {
    return _repository.requestOtp(email);
  }
}
