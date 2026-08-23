import 'package:restropulse/src/core/errors/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class SupabaseFailureMapper {
  const SupabaseFailureMapper._();

  static SupabaseFailure map(AuthException exception) {
    final message = switch (exception) {
      AuthRetryableFetchException() =>
        'Unable to connect. Check your internet connection.',

      AuthSessionMissingException() =>
        'Your session has expired. Please sign in again.',

      AuthWeakPasswordException() => 'Choose a stronger password.',

      AuthInvalidJwtException() =>
        'Your session is invalid. Please sign in again.',

      AuthUnknownException() => 'An unexpected authentication error occurred.',

      AuthException() => _messageFromCode(exception.code, exception.statusCode),
    };

    return SupabaseFailure(
      message,
      supabaseCode: exception.code,
      supabaseStatusCode: exception.statusCode,
    );
  }

  static String _messageFromCode(String? code, String? statusCode) {
    return switch (code) {
      'invalid_credentials' => 'The email or password is incorrect.',

      'user_not_found' => 'No account was found for this user.',

      'email_not_confirmed' => 'Confirm your email before signing in.',

      'user_already_exists' ||
      'email_exists' ||
      'identity_already_exists' => 'An account already exists for this email.',

      'signup_disabled' ||
      'email_provider_disabled' ||
      'provider_disabled' => 'This sign-in method is currently unavailable.',

      'user_banned' => 'This account is currently unavailable.',

      'weak_password' => 'Choose a stronger password.',

      'same_password' =>
        'Your new password must be different from your current password.',

      'otp_expired' => 'This verification code has expired. Request a new one.',

      'captcha_failed' => 'Verification failed. Please try again.',

      'session_expired' ||
      'session_not_found' ||
      'session_missing' => 'Your session has expired. Please sign in again.',

      'over_request_rate_limit' ||
      'over_email_send_rate_limit' ||
      'over_sms_send_rate_limit' =>
        'Too many attempts. Please wait before trying again.',

      'request_timeout' => 'The request timed out. Please try again.',

      _ => _messageFromStatus(statusCode),
    };
  }

  static String _messageFromStatus(String? statusCode) {
    return switch (statusCode) {
      '401' => 'Authentication failed. Please sign in again.',
      '403' => 'You do not have permission to perform this operation.',
      '404' => 'The authentication service could not be reached.',
      '422' => 'The submitted authentication information is invalid.',
      '429' => 'Too many attempts. Please try again later.',
      '500' ||
      '502' ||
      '503' ||
      '504' => 'The authentication service is temporarily unavailable.',
      _ => 'Authentication could not be completed. Please try again.',
    };
  }
}
