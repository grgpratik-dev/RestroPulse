import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/country.dart';

part 'country_model.freezed.dart';
part 'country_model.g.dart';

@freezed
abstract class CountryModel with _$CountryModel {
  const CountryModel._();
  const factory CountryModel({
    required String code,
    required String name,
    required String flag,
    required List<String> currencyCodes,
    String? defaultCurrencyCode,
  }) = _CountryModel;

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Country toEntity() => Country(
    code: code,
    name: name,
    flag: flag,
    currencyCodes: List.unmodifiable(currencyCodes),
    defaultCurrencyCode: defaultCurrencyCode,
  );
}
