import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin gateway around Supabase authentication operations.
final class SupabaseService {
  final _supabase = Supabase.instance.client;

  Future<void> requestOtp(String email) =>
      _supabase.auth.signInWithOtp(email: email);

  Future<AuthResponse> verifyOtp({
    required String email,
    required String token,
  }) =>
      _supabase.auth.verifyOTP(email: email, token: token, type: OtpType.email);

  Future<AuthResponse> signInWithGoogle({
    required String idToken,
    required String accessToken,
  }) => _supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );

  Future<void> signOut() => _supabase.auth.signOut();

  Session? get currentSession => _supabase.auth.currentSession;

  bool get isAuthenticated => currentSession != null;

  String? get accessToken => currentSession?.accessToken;

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  SupabaseClient get supabaseClient => _supabase;
}
