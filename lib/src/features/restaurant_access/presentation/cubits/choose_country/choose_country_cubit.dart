import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/country.dart';
import '../../../domain/repositories/country_repository.dart';
import 'choose_country_state.dart';

final class ChooseCountryCubit extends Cubit<ChooseCountryState> {
  ChooseCountryCubit(this._repository) : super(const ChooseCountryState());
  final CountryRepository _repository;

  Future<void> load({String? initialCountry}) async {
    if (state.status == ChooseCountryStatus.loading) return;
    emit(state.copyWith(status: ChooseCountryStatus.loading, message: null));
    final result = await _repository.getCountries();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ChooseCountryStatus.failure,
          message: failure.message,
        ),
      ),
      (countries) {
        final initial = initialCountry?.trim().toLowerCase();
        final selected =
            state.selectedCountry ??
            countries
                .where(
                  (country) =>
                      country.code.toLowerCase() == initial ||
                      country.name.toLowerCase() == initial,
                )
                .firstOrNull;
        emit(
          state.copyWith(
            status: ChooseCountryStatus.success,
            countries: countries,
            filteredCountries: _filter(countries, state.query),
            selectedCountry: selected,
          ),
        );
      },
    );
  }

  void search(String query) {
    emit(
      state.copyWith(
        query: query,
        filteredCountries: _filter(state.countries, query),
      ),
    );
  }

  void select(Country country) {
    final selected = state.countries
        .where((item) => item.code == country.code)
        .firstOrNull;
    if (selected != null) emit(state.copyWith(selectedCountry: selected));
  }

  List<Country> _filter(List<Country> countries, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return countries;
    return countries
        .where(
          (country) =>
              country.name.toLowerCase().contains(normalized) ||
              country.code.toLowerCase().contains(normalized) ||
              country.currencyCodes.any(
                (code) => code.toLowerCase().contains(normalized),
              ),
        )
        .toList();
  }
}
