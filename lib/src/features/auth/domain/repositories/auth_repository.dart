import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> requestOtp(String email);

  Future<Either<Failure, void>> verifyOtp(String email, String token);

  Future<Either<Failure, void>> signOut();
}
