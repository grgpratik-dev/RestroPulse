import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/restaurant_access.dart';
import '../repositories/restaurant_access_repository.dart';

final class GetCurrentRestaurantAccessUsecase
    extends UseCase<RestaurantAccess?, NoParams> {
  GetCurrentRestaurantAccessUsecase(this._repository);

  final RestaurantAccessRepository _repository;

  @override
  Future<Either<Failure, RestaurantAccess?>> call(NoParams params) {
    return _repository.getCurrentRestaurantAccess();
  }
}
