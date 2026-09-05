import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/core/services/network/supabase_service.dart';
import 'package:restropulse/src/features/restaurant_access/data/datasources/restaurant_access_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('RestaurantAccessRemoteDatasourceImpl', () {
    test('throws AuthException with session_missing code when user is not authenticated', () async {
      final service = _FakeSupabaseService(mockUser: null);
      final datasource = RestaurantAccessRemoteDatasourceImpl(service);

      expect(
        () => datasource.getCurrentRestaurantAccess(),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            'session_missing',
          ),
        ),
      );
    });
  });
}

class _FakeSupabaseService extends SupabaseService {
  _FakeSupabaseService({this.mockUser});

  final User? mockUser;

  @override
  User? get currentUser => mockUser;
}
