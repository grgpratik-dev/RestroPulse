import 'package:restropulse/src/core/services/network/google_service.dart';
import 'package:restropulse/src/core/services/network/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDatasource {
  Future<void> requestOtp(String email);

  Future<AuthResponse> verifyOtp(String email, String token);

  Future<AuthResponse> signInWithGoogle();

  Future<void> signOut();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl(this._authService, this._googleService);
  final SupabaseService _authService;
  final GoogleService _googleService;

  @override
  Future<void> signOut() async {
    await Future.wait([_authService.signOut(), _googleService.signOut()]);
  }

  @override
  Future<void> requestOtp(String email) {
    return _authService.requestOtp(email);
  }

  @override
  Future<AuthResponse> verifyOtp(String email, String token) {
    return _authService.verifyOtp(email: email, token: token);
  }

  @override
  Future<AuthResponse> signInWithGoogle() async {
    final tokens = await _googleService.signIn();
    return _authService.signInWithGoogle(
      idToken: tokens.idToken,
      accessToken: tokens.accessToken,
    );
  }
}
