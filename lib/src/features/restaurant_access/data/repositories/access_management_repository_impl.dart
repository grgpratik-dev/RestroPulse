import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/access_management.dart';
import '../../domain/repositories/access_management_repository.dart';
import '../datasources/access_management_datasource.dart';

final class AccessManagementRepositoryImpl
    implements AccessManagementRepository {
  AccessManagementRepositoryImpl(this._datasource);
  final AccessManagementDatasource _datasource;

  @override
  Future<Either<Failure, JoinInvitation>> resolveCode(
    String code,
  ) => _guard(() async {
    final invitation = await _datasource.resolveCode(code.trim().toUpperCase());
    if (invitation == null) {
      return const Left(
        UnknownFailure(
          'This code is invalid or disabled. Ask the owner for an active code.',
        ),
      );
    }
    return Right(invitation.toEntity());
  });
  @override
  Future<Either<Failure, MembersAccess>> getMembersAccess() => _guard(
    () async => Right((await _datasource.getMembersAccess()).toEntity()),
  );
  @override
  Future<Either<Failure, Unit>> requestJoin(String code) =>
      _action(() => _datasource.requestJoin(code.trim().toUpperCase()));
  @override
  Future<Either<Failure, Unit>> generateCode() =>
      _action(_datasource.generateCode);
  @override
  Future<Either<Failure, Unit>> disableCode() =>
      _action(_datasource.disableCode);
  @override
  Future<Either<Failure, Unit>> approve(String id) =>
      _action(() => _datasource.approve(id));
  @override
  Future<Either<Failure, Unit>> decline(String id) =>
      _action(() => _datasource.decline(id));
  @override
  Future<Either<Failure, Unit>> removeViewer(String id) =>
      _action(() => _datasource.removeViewer(id));

  Future<Either<Failure, Unit>> _action(Future<void> Function() action) =>
      _guard(() async {
        await action();
        return const Right(unit);
      });
  Future<Either<Failure, T>> _guard<T>(
    Future<Either<Failure, T>> Function() action,
  ) async {
    try {
      return await action();
    } on AuthException {
      return const Left(
        UnknownFailure('Please sign in again to manage restaurant access.'),
      );
    } on PostgrestException catch (error) {
      final message = switch (error.message) {
        'Invalid or inactive restaurant join code' =>
          'This code is no longer active. Ask the owner for a new code.',
        'User already belongs to a restaurant' =>
          'You already have restaurant access. Refresh your access to continue.',
        'Requester already belongs to a restaurant' =>
          'This person has already joined a restaurant. Decline this request.',
        'Join request has already been processed' || 'Join request not found' =>
          'This request has changed. Refresh the list to see its current status.',
        _ => switch (error.code) {
          '42501' => 'Only the restaurant owner can manage access.',
          '23503' =>
            'An account profile is missing. Contact support to complete account setup.',
          'PGRST202' =>
            'Access management is temporarily unavailable. Please contact support.',
          _ =>
            'Could not update restaurant access. Please refresh and try again.',
        },
      };
      return Left(SupabaseFailure(message, supabaseCode: error.code));
    } catch (_) {
      return const Left(
        UnknownFailure(
          'Could not load or update restaurant access. Please try again.',
        ),
      );
    }
  }
}
