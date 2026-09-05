import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/features/restaurant_access/data/datasources/restaurant_access_remote_datasource.dart';
import 'package:restropulse/src/features/restaurant_access/data/models/restaurant_access_model.dart';
import 'package:restropulse/src/features/restaurant_access/data/models/restaurant_join_request_model.dart';
import 'package:restropulse/src/features/restaurant_access/data/models/restaurant_membership_model.dart';
import 'package:restropulse/src/features/restaurant_access/data/repositories/restaurant_access_repository_impl.dart';
import 'package:restropulse/src/features/restaurant_access/domain/entities/restaurant_access.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('RestaurantAccessRepositoryImpl', () {
    test('returns hasRestaurant access when membership exists', () async {
      final datasource = _FakeRestaurantAccessRemoteDatasource(
        result: const RestaurantAccessModel.hasRestaurant(
          membership: RestaurantMembershipModel(
            restaurantId: 'restaurant-1',
            role: RestaurantRole.owner,
          ),
        ),
      );
      final repository = RestaurantAccessRepositoryImpl(datasource);

      final result = await repository.getCurrentRestaurantAccess();

      result.fold(
        (failure) => fail('Expected access, received $failure'),
        (access) {
          expect(access.status, RestaurantAccessStatus.hasRestaurant);
          expect(access, isA<HasRestaurantAccess>());
          expect(access.restaurantId, 'restaurant-1');
          expect(access.role, RestaurantRole.owner);
          expect(access.hasRestaurant, isTrue);
          expect(access.isOwner, isTrue);
        },
      );
    });

    test('returns pendingJoinRequest access when a pending request exists', () async {
      final datasource = _FakeRestaurantAccessRemoteDatasource(
        result: const RestaurantAccessModel.pendingJoinRequest(
          request: RestaurantJoinRequestModel(
            id: 'req-1',
            restaurantId: 'restaurant-2',
            requesterProfileId: 'profile-1',
            status: 'pending',
          ),
        ),
      );
      final repository = RestaurantAccessRepositoryImpl(datasource);

      final result = await repository.getCurrentRestaurantAccess();

      result.fold(
        (failure) => fail('Expected pending access, received $failure'),
        (access) {
          expect(access.status, RestaurantAccessStatus.pendingJoinRequest);
          expect(access, isA<PendingJoinRequestAccess>());
          expect(access.restaurantId, 'restaurant-2');
          expect(access.role, isNull);
          expect(access.isPending, isTrue);
          final pending = access as PendingJoinRequestAccess;
          expect(pending.requestId, 'req-1');
          expect(pending.request.requesterProfileId, 'profile-1');
        },
      );
    });

    test('returns noRestaurant when neither membership nor pending request exists', () async {
      final repository = RestaurantAccessRepositoryImpl(
        _FakeRestaurantAccessRemoteDatasource(
          result: const RestaurantAccessModel.noRestaurant(),
        ),
      );

      final result = await repository.getCurrentRestaurantAccess();

      result.fold(
        (failure) => fail('Expected access, received $failure'),
        (access) {
          expect(access.status, RestaurantAccessStatus.noRestaurant);
          expect(access, isA<NoRestaurantAccess>());
          expect(access.restaurantId, isNull);
          expect(access.isNoRestaurant, isTrue);
        },
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

    test('maps AuthException without exposing sensitive details', () async {
      final repository = RestaurantAccessRepositoryImpl(
        _FakeRestaurantAccessRemoteDatasource(
          exception: const AuthException(
            'Session has expired',
            code: 'session_expired',
          ),
        ),
      );

      final result = await repository.getCurrentRestaurantAccess();

      result.fold((failure) {
        expect(failure, isA<SupabaseFailure>());
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
  Future<RestaurantAccessModel> getCurrentRestaurantAccess() async {
    final exception = this.exception;
    if (exception != null) throw exception;
    return result ?? const RestaurantAccessModel.noRestaurant();
  }
}
