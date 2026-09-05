import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/core/usecase/usecase.dart';
import 'package:restropulse/src/features/restaurant_access/domain/entities/restaurant_access.dart';
import 'package:restropulse/src/features/restaurant_access/domain/repositories/restaurant_access_repository.dart';
import 'package:restropulse/src/features/restaurant_access/domain/usecases/get_current_restaurant_access_usecase.dart';

void main() {
  group('GetCurrentRestaurantAccessUsecase', () {
    test('returns access when repository succeeds', () async {
      const access = RestaurantAccess.hasRestaurant(
        membership: RestaurantMembership(
          restaurantId: 'rest-1',
          role: RestaurantRole.owner,
        ),
      );
      final repository = _FakeRestaurantAccessRepository(
        result: const Right(access),
      );
      final usecase = GetCurrentRestaurantAccessUsecase(repository);

      final result = await usecase(NoParams());

      expect(result, const Right(access));
    });

    test('returns failure when repository fails', () async {
      const failure = SupabaseFailure('Network error');
      final repository = _FakeRestaurantAccessRepository(
        result: const Left(failure),
      );
      final usecase = GetCurrentRestaurantAccessUsecase(repository);

      final result = await usecase(NoParams());

      expect(result, const Left(failure));
    });
  });
}

final class _FakeRestaurantAccessRepository
    implements RestaurantAccessRepository {
  _FakeRestaurantAccessRepository({required this.result});

  final Either<Failure, RestaurantAccess> result;

  @override
  Future<Either<Failure, RestaurantAccess>> getCurrentRestaurantAccess() async {
    return result;
  }
}
