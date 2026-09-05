import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';

abstract class CreateRestaurantRepository {
  Future<Either<Failure, String>> create({
    required String name,
    required String countryCode,
    required String currencyCode,
    required String address,
    required String phone,
  });
  Future<Either<Failure, Unit>> uploadLogo(
    String restaurantId,
    Uint8List bytes,
  );
}
