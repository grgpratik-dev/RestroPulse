import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/core/errors/mappers/google_sign_in_failure_mapper.dart';
import 'package:restropulse/src/core/errors/mappers/supabase_failure_mapper.dart';
import 'package:restropulse/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:restropulse/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authRemoteDatasource);
  final AuthRemoteDatasource _authRemoteDatasource;

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authRemoteDatasource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(SupabaseFailureMapper.map(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestOtp(String email) async {
    try {
      await _authRemoteDatasource.requestOtp(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(SupabaseFailureMapper.map(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signInWithGoogle() async {
    try {
      await _authRemoteDatasource.signInWithGoogle();
      return const Right(null);
    } on GoogleSignInException catch (e) {
      return Left(GoogleSignInFailureMapper.map(e));
    } on AuthException catch (e) {
      return Left(SupabaseFailureMapper.map(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String email, String token) async {
    try {
      await _authRemoteDatasource.verifyOtp(email, token);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(SupabaseFailureMapper.map(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
