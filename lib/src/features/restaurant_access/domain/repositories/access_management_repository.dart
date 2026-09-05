import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/access_management.dart';

abstract class AccessManagementRepository {
  Future<Either<Failure, JoinInvitation>> resolveCode(String code);
  Future<Either<Failure, Unit>> requestJoin(String code);
  Future<Either<Failure, MembersAccess>> getMembersAccess();
  Future<Either<Failure, Unit>> generateCode();
  Future<Either<Failure, Unit>> disableCode();
  Future<Either<Failure, Unit>> approve(String requestId);
  Future<Either<Failure, Unit>> decline(String requestId);
  Future<Either<Failure, Unit>> removeViewer(String profileId);
}
