import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/features/restaurant_access/data/datasources/restaurant_access_remote_datasource.dart';
import 'package:restropulse/src/features/restaurant_access/data/models/restaurant_access_model.dart';
import 'package:restropulse/src/features/restaurant_access/data/repositories/restaurant_access_repository_impl.dart';
import 'package:restropulse/src/features/restaurant_access/domain/entities/restaurant_access.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('RestaurantAccessRepositoryImpl', () {
    test('returns active restaurant access when membership exists', () async {
      final datasource = _FakeRestaurantAccessRemoteDatasource(
        result: const RestaurantAccessModel(
          restaurantId: 'restaurant-1',
          role: RestaurantRole.owner,
        ),
      );
      final repository = RestaurantAccessRepositoryImpl(datasource);

      final result = await repository.getCurrentRestaurantAccess();

      result.fold((failure) => fail('Expected access, received $failure'), (
        access,
      ) {
        expect(access?.restaurantId, 'restaurant-1');
        expect(access?.type, RestaurantAccessType.active);
        expect(access?.role, RestaurantRole.owner);
      });
    });

    test('returns pending access when a pending request exists', () async {
      final datasource = _FakeRestaurantAccessRemoteDatasource(
        result: const RestaurantAccessModel(
          restaurantId: 'restaurant-2',
          requestStatus: 'pending',
        ),
      );
      final repository = RestaurantAccessRepositoryImpl(datasource);

      final result = await repository.getCurrentRestaurantAccess();

      result.fold(
        (failure) => fail('Expected pending access, received $failure'),
        (access) {
          expect(access?.restaurantId, 'restaurant-2');
          expect(access?.type, RestaurantAccessType.pending);
          expect(access?.role, isNull);
        },
      );
    });

    test('returns null when no membership or pending request exists', () async {
      final repository = RestaurantAccessRepositoryImpl(
        _FakeRestaurantAccessRemoteDatasource(),
      );

      final result = await repository.getCurrentRestaurantAccess();

      result.fold(
        (failure) => fail('Expected no access, received $failure'),
        (access) => expect(access, isNull),
      );
    });

    test('maps database exceptions without exposing raw messages', () async {
      final repository = RestaurantAccessRepositoryImpl(
        _FakeRestaurantAccessRemoteDatasource(
          exception: const PostgrestException(
            message: 'sensitive database detail',
            code: '42501',
          ),
        ),
      );

      final result = await repository.getCurrentRestaurantAccess();

      result.fold((failure) {
        expect(failure, isA<SupabaseFailure>());
        expect(failure.message, isNot(contains('sensitive')));
      }, (_) => fail('Expected a failure'));
    });
  });
}

final class _FakeRestaurantAccessRemoteDatasource
    implements RestaurantAccessRemoteDatasource {
  _FakeRestaurantAccessRemoteDatasource({this.result, this.exception});

  final RestaurantAccessModel? result;
  final Object? exception;

  @override
  Future<RestaurantAccessModel?> getCurrentRestaurantAccess() async {
    final exception = this.exception;
    if (exception != null) throw exception;
    return result;
  }
}
