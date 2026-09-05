import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/country.dart';

part 'choose_country_state.freezed.dart';

enum ChooseCountryStatus { initial, loading, success, failure }

@freezed
abstract class ChooseCountryState with _$ChooseCountryState {
  const factory ChooseCountryState({
    @Default(ChooseCountryStatus.initial) ChooseCountryStatus status,
    @Default(<Country>[]) List<Country> countries,
    @Default(<Country>[]) List<Country> filteredCountries,
    @Default('') String query,
    Country? selectedCountry,
    String? message,
  }) = _ChooseCountryState;
}
