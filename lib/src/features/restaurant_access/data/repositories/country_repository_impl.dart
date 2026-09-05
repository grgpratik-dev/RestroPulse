import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';
import '../models/country_model.dart';

final class CountryRepositoryImpl implements CountryRepository {
  CountryRepositoryImpl(this._bundle);
  final AssetBundle _bundle;
  List<Country>? _cachedCountries;

  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    final cached = _cachedCountries;
    if (cached != null) return Right(cached);
    try {
      final source = await _bundle.loadString('assets/data/countries.json');
      final entries = jsonDecode(source) as List<dynamic>;
      final countries = List<Country>.unmodifiable(
        entries.map(
          (entry) =>
              CountryModel.fromJson(entry as Map<String, dynamic>).toEntity(),
        ),
      );
      _cachedCountries = countries;
      return Right(countries);
    } catch (_) {
      return const Left(
        UnknownFailure('Countries could not be loaded. Please try again.'),
      );
    }
  }
}
