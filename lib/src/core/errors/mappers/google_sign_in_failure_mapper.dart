import 'package:google_sign_in/google_sign_in.dart';
import 'package:restropulse/src/core/errors/failures.dart';

final class GoogleSignInFailureMapper {
  const GoogleSignInFailureMapper._();

  static Failure map(GoogleSignInException exception) {
    if (exception.code == GoogleSignInExceptionCode.canceled) {
      return const AuthCancelledFailure();
    }

    final message = switch (exception.code) {
      GoogleSignInExceptionCode.interrupted =>
        'Google sign-in was interrupted. Please try again.',
      GoogleSignInExceptionCode.clientConfigurationError ||
      GoogleSignInExceptionCode.providerConfigurationError =>
        'Google sign-in is currently unavailable.',
      GoogleSignInExceptionCode.uiUnavailable =>
        'Could not open Google sign-in. Please try again.',
      GoogleSignInExceptionCode.userMismatch =>
        'Please continue with the same Google account.',
      _ => 'Could not sign in with Google. Please try again.',
    };

    return GoogleSignInFailure(message, googleCode: exception.code.name);
  }
}
