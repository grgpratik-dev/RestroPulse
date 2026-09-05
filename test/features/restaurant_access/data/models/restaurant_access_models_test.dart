import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/features/restaurant_access/data/models/restaurant_access_model.dart';
import 'package:restropulse/src/features/restaurant_access/data/models/restaurant_join_request_model.dart';
import 'package:restropulse/src/features/restaurant_access/data/models/restaurant_membership_model.dart';
import 'package:restropulse/src/features/restaurant_access/domain/entities/restaurant_access.dart';

void main() {
  group('RestaurantAccess Models and Entities', () {
    test('RestaurantMembershipModel parses from JSON and maps to entity', () {
      final json = {'restaurant_id': 'rest-123', 'role': 'owner'};
      final model = RestaurantMembershipModel.fromJson(json);

      expect(model.restaurantId, 'rest-123');
      expect(model.role, RestaurantRole.owner);

      final entity = model.toEntity();
      expect(entity.restaurantId, 'rest-123');
      expect(entity.role, RestaurantRole.owner);
    });

    test('RestaurantJoinRequestModel parses from JSON and maps to entity', () {
      final json = {
        'id': 'req-456',
        'restaurant_id': 'rest-123',
        'requester_profile_id': 'profile-789',
        'status': 'pending',
        'created_at': '2026-09-01T12:00:00.000Z',
      };
      final model = RestaurantJoinRequestModel.fromJson(json);

      expect(model.id, 'req-456');
      expect(model.restaurantId, 'rest-123');
      expect(model.requesterProfileId, 'profile-789');
      expect(model.status, 'pending');
      expect(model.createdAt, DateTime.parse('2026-09-01T12:00:00.000Z'));

      final entity = model.toEntity();
      expect(entity.id, 'req-456');
      expect(entity.restaurantId, 'rest-123');
      expect(entity.requesterProfileId, 'profile-789');
      expect(entity.status, 'pending');
      expect(entity.createdAt, DateTime.parse('2026-09-01T12:00:00.000Z'));
    });

    test('RestaurantAccessModel variants correctly map to domain RestaurantAccess', () {
      const membershipModel = RestaurantMembershipModel(
        restaurantId: 'rest-123',
        role: RestaurantRole.viewer,
      );
      final hasRestaurantModel = const RestaurantAccessModel.hasRestaurant(
        membership: membershipModel,
      );
      final hasRestaurantEntity = hasRestaurantModel.toEntity();

      expect(hasRestaurantEntity.status, RestaurantAccessStatus.hasRestaurant);
      expect(hasRestaurantEntity, isA<HasRestaurantAccess>());
      expect(hasRestaurantEntity.restaurantId, 'rest-123');
      expect(hasRestaurantEntity.role, RestaurantRole.viewer);
      expect(hasRestaurantEntity.type, RestaurantAccessType.active);
      expect(hasRestaurantEntity.isActive, isTrue);
      expect(hasRestaurantEntity.isOwner, isFalse);

      const requestModel = RestaurantJoinRequestModel(
        id: 'req-1',
        restaurantId: 'rest-456',
        status: 'pending',
      );
      final pendingModel = const RestaurantAccessModel.pendingJoinRequest(
        request: requestModel,
      );
      final pendingEntity = pendingModel.toEntity();

      expect(pendingEntity.status, RestaurantAccessStatus.pendingJoinRequest);
      expect(pendingEntity, isA<PendingJoinRequestAccess>());
      expect(pendingEntity.restaurantId, 'rest-456');
      expect(pendingEntity.role, isNull);
      expect(pendingEntity.type, RestaurantAccessType.pending);
      expect(pendingEntity.isPending, isTrue);

      const noRestaurantModel = RestaurantAccessModel.noRestaurant();
      final noRestaurantEntity = noRestaurantModel.toEntity();

      expect(noRestaurantEntity.status, RestaurantAccessStatus.noRestaurant);
      expect(noRestaurantEntity, isA<NoRestaurantAccess>());
      expect(noRestaurantEntity.restaurantId, isNull);
      expect(noRestaurantEntity.role, isNull);
      expect(noRestaurantEntity.type, isNull);
      expect(noRestaurantEntity.isNoRestaurant, isTrue);
    });
  });
}
