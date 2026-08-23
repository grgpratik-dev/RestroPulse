import 'package:restropulse/src/core/services/network/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDatasource {
  Future<void> requestOtp(String email);

  Future<AuthResponse> verifyOtp(String email, String token);

  Future<void> signOut();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl(this._authService);
  final SupabaseService _authService;

  @override
  Future<void> signOut() {
    return _authService.signOut();
  }

  @override
  Future<void> requestOtp(String email) {
    return _authService.requestOtp(email);
  }

  @override
  Future<AuthResponse> verifyOtp(String email, String token) {
    return _authService.verifyOtp(email: email, token: token);
  }
}
