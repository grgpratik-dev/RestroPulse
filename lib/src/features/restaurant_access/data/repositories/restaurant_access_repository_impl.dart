import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/mappers/supabase_failure_mapper.dart';
import '../../domain/entities/restaurant_access.dart';
import '../../domain/repositories/restaurant_access_repository.dart';
import '../datasources/restaurant_access_remote_datasource.dart';

final class RestaurantAccessRepositoryImpl
    implements RestaurantAccessRepository {
  RestaurantAccessRepositoryImpl(this._remoteDatasource);

  final RestaurantAccessRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, RestaurantAccess?>>
  getCurrentRestaurantAccess() async {
    try {
      final model = await _remoteDatasource.getCurrentRestaurantAccess();
      return Right(model?.toEntity());
    } on AuthException catch (exception) {
      return Left(SupabaseFailureMapper.map(exception));
    } on PostgrestException catch (exception) {
      return Left(SupabaseFailureMapper.mapPostgrest(exception));
    } on FormatException {
      return const Left(
        SupabaseFailure('Restaurant access data could not be read.'),
      );
    } catch (_) {
      return const Left(
        UnknownFailure('Restaurant access could not be checked.'),
      );
    }
  }
}
