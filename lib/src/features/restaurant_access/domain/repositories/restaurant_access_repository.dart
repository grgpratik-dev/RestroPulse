import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/restaurant_access.dart';

abstract class RestaurantAccessRepository {
  Future<Either<Failure, RestaurantAccess?>> getCurrentRestaurantAccess();
}
