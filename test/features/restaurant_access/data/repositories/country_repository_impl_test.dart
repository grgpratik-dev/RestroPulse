import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restropulse/src/features/restaurant_access/data/repositories/country_repository_impl.dart';

void main() {
  test('parses all bundled countries and caches the result', () async {
    final bundle = _Bundle(
      File('assets/data/countries.json').readAsStringSync(),
    );
    final repository = CountryRepositoryImpl(bundle);
    final result = await repository.getCountries();
    result.fold((failure) => fail(failure.message), (countries) {
      expect(countries.length, 250);
      expect(countries.map((c) => c.code).toSet().length, 250);
      expect(
        countries.firstWhere((c) => c.code == 'NP').defaultCurrencyCode,
        'NPR',
      );
      expect(
        countries.firstWhere((c) => c.code == 'AQ').defaultCurrencyCode,
        isNull,
      );
      expect(() => countries.clear(), throwsUnsupportedError);
    });
    await repository.getCountries();
    expect(bundle.loads, 1);
  });

  test(
    'maps missing or malformed assets to a safe failure and permits retry',
    () async {
      for (final source in [null, 'invalid JSON', '[{"code":"NP"}]']) {
        final bundle = _Bundle(source);
        final repository = CountryRepositoryImpl(bundle);
        final result = await repository.getCountries();
        result.fold(
          (failure) => expect(
            failure.message,
            'Countries could not be loaded. Please try again.',
          ),
          (_) => fail('Expected failure'),
        );
        bundle.source = File('assets/data/countries.json').readAsStringSync();
        expect((await repository.getCountries()).isRight(), isTrue);
      }
    },
  );
}

class _Bundle extends CachingAssetBundle {
  _Bundle(this.source);
  String? source;
  int loads = 0;
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    expect(key, 'assets/data/countries.json');
    loads++;
    return source ?? (throw StateError('sensitive asset path'));
  }

  @override
  Future<ByteData> load(String key) => throw UnimplementedError();
}
