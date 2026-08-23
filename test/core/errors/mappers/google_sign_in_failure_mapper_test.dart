import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/core/errors/mappers/google_sign_in_failure_mapper.dart';

void main() {
  test('maps a closed Google picker to authentication cancellation', () {
    const exception = GoogleSignInException(
      code: GoogleSignInExceptionCode.canceled,
    );

    final failure = GoogleSignInFailureMapper.map(exception);

    expect(failure, const AuthCancelledFailure());
  });

  test('maps Google configuration errors to a safe message', () {
    const exception = GoogleSignInException(
      code: GoogleSignInExceptionCode.providerConfigurationError,
      description: 'Sensitive provider details',
    );

    final failure = GoogleSignInFailureMapper.map(exception);

    expect(
      failure,
      const GoogleSignInFailure(
        'Google sign-in is currently unavailable.',
        googleCode: 'providerConfigurationError',
      ),
    );
  });
}
