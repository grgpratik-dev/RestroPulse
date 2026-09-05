import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restropulse/src/core/errors/failures.dart';
import 'package:restropulse/src/features/restaurant_access/domain/entities/country.dart';
import 'package:restropulse/src/features/restaurant_access/domain/repositories/country_repository.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/cubits/choose_country/choose_country_cubit.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/cubits/choose_country/choose_country_state.dart';

const countries = [
  Country(
    code: 'NP',
    name: 'Nepal',
    flag: '🇳🇵',
    currencyCodes: ['NPR'],
    defaultCurrencyCode: 'NPR',
  ),
  Country(
    code: 'US',
    name: 'United States',
    flag: '🇺🇸',
    currencyCodes: ['USD'],
    defaultCurrencyCode: 'USD',
  ),
];

void main() {
  test(
    'restores selection by code or legacy name and rejects unknown initial values',
    () async {
      for (final initial in ['np', 'Nepal', 'unknown']) {
        final cubit = ChooseCountryCubit(_Repository());
        await cubit.load(initialCountry: initial);
        expect(
          cubit.state.selectedCountry?.code,
          initial == 'unknown' ? null : 'NP',
        );
        await cubit.close();
      }
    },
  );

  test(
    'filters names, codes and currencies, clears results, and retains selection',
    () async {
      final cubit = ChooseCountryCubit(_Repository());
      addTearDown(cubit.close);
      await cubit.load();
      cubit.select(countries.first);
      for (final query in [' nEp ', 'NP', 'npr']) {
        cubit.search(query);
        expect(cubit.state.filteredCountries.map((c) => c.code), ['NP']);
      }
      cubit.search('usd');
      expect(cubit.state.filteredCountries.map((c) => c.code), ['US']);
      expect(cubit.state.selectedCountry?.code, 'NP');
      cubit.search('not-a-country');
      expect(cubit.state.filteredCountries, isEmpty);
      cubit.search('  ');
      expect(cubit.state.filteredCountries, countries);
    },
  );

  test('supports retry after failure', () async {
    final repository = _Repository()..fail = true;
    final cubit = ChooseCountryCubit(repository);
    addTearDown(cubit.close);
    await cubit.load();
    expect(cubit.state.status, ChooseCountryStatus.failure);
    repository.fail = false;
    await cubit.load(initialCountry: 'NP');
    expect(cubit.state.status, ChooseCountryStatus.success);
    expect(cubit.state.message, isNull);
    expect(cubit.state.selectedCountry?.code, 'NP');
  });

  test(
    'preserves a query typed during loading and ignores completion after close',
    () async {
      final repository = _Repository()..pending = Completer();
      final cubit = ChooseCountryCubit(repository);
      final loading = cubit.load();
      cubit.search('usd');
      repository.pending!.complete(const Right(countries));
      await loading;
      expect(cubit.state.filteredCountries.map((c) => c.code), ['US']);
      await cubit.close();

      final delayed = _Repository()..pending = Completer();
      final closedCubit = ChooseCountryCubit(delayed);
      final pendingLoad = closedCubit.load();
      await closedCubit.close();
      delayed.pending!.complete(const Right(countries));
      await pendingLoad;
    },
  );
}

class _Repository implements CountryRepository {
  bool fail = false;
  Completer<Either<Failure, List<Country>>>? pending;
  @override
  Future<Either<Failure, List<Country>>> getCountries() async => pending != null
      ? pending!.future
      : fail
      ? const Left(UnknownFailure('Try again.'))
      : const Right(countries);
}
