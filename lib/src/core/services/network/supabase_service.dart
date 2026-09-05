import 'package:supabase_flutter/supabase_flutter.dart';
import '../../logging/operation_logger.dart';

/// Thin gateway around Supabase operations.
class SupabaseService {
  SupabaseService([SupabaseClient? client]) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  Future<void> requestOtp(String email) => operationLogger.run(
    'auth / request OTP',
    () => _supabase.auth.signInWithOtp(email: email),
  );

  Future<AuthResponse> verifyOtp({
    required String email,
    required String token,
  }) => operationLogger.run(
    'auth / verify OTP',
    () => _supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.email,
    ),
  );

  Future<AuthResponse> signInWithGoogle({
    required String idToken,
    required String accessToken,
  }) => operationLogger.run(
    'auth / Google sign-in',
    () => _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    ),
  );

  Future<void> signOut() =>
      operationLogger.run('auth / sign out', _supabase.auth.signOut);

  Session? get currentSession => _supabase.auth.currentSession;

  bool get isAuthenticated => currentSession != null;

  String? get accessToken => currentSession?.accessToken;

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  SupabaseClient get supabaseClient => _supabase;
}
