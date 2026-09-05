import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/country.dart';

abstract class CountryRepository {
  Future<Either<Failure, List<Country>>> getCountries();
}
