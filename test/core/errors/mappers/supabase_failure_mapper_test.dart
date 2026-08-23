import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/core/errors/mappers/supabase_failure_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('maps user_not_found by code', () {
    const exception = AuthApiException(
      'User not found',
      statusCode: '404',
      code: 'user_not_found',
    );

    final failure = SupabaseFailureMapper.map(exception);

    expect(failure.message, 'No account was found for this user.');
  });

  test('does not describe every auth 404 as a missing user', () {
    const exception = AuthApiException('Route not found', statusCode: '404');

    final failure = SupabaseFailureMapper.map(exception);

    expect(failure.message, 'The authentication service could not be reached.');
  });
}
