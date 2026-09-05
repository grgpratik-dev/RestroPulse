import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_state_message.dart';
import 'package:restropulse/src/core/widgets/app_text_form_field.dart';

import '../cubits/choose_country/choose_country_cubit.dart';
import '../cubits/choose_country/choose_country_state.dart';

class CountryPickerSheet extends StatefulWidget {
  const CountryPickerSheet({this.initialCountry, super.key});
  final String? initialCountry;

  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.35,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) =>
              BlocBuilder<ChooseCountryCubit, ChooseCountryState>(
                builder: (context, state) {
                  void search(String query) {
                    context.read<ChooseCountryCubit>().search(query);
                    if (scrollController.hasClients) scrollController.jumpTo(0);
                  }

                  return CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      PinnedHeaderSliver(
                        child: ColoredBox(
                          color: colors.surface,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.spaceLg,
                              AppSpacing.spaceXs,
                              AppSpacing.spaceLg,
                              AppSpacing.spaceMd,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Select country',
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(color: colors.onSurface),
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Close country picker',
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: SvgPicture.asset(
                                        AppIcons.close_rounded,
                                        width: AppSpacing.spaceMd,
                                        height: AppSpacing.spaceMd,
                                        colorFilter: ColorFilter.mode(
                                          colors.onSurfaceVariant,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.spaceLg),
                                Theme(
                                  data: theme.copyWith(
                                    inputDecorationTheme: theme
                                        .inputDecorationTheme
                                        .copyWith(
                                          filled: true,
                                          fillColor: colors.surfaceContainerLow,
                                          hintStyle: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: colors.onSurfaceVariant,
                                              ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: AppSpacing.spaceMd,
                                                vertical: AppSpacing.spaceMd,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppRadius.md,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppRadius.md,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppRadius.md,
                                            ),
                                            borderSide: BorderSide(
                                              color: colors.primary,
                                            ),
                                          ),
                                        ),
                                  ),
                                  child: AppTextFormField(
                                    key: const ValueKey('country-search-field'),
                                    controller: _searchController,
                                    hintText: 'Search country or currency',
                                    style: theme.textTheme.bodyMedium,
                                    inputType: AppTextFieldInputType.search,
                                    textInputAction: TextInputAction.search,
                                    autocorrect: false,
                                    onChanged: search,
                                    prefixIcon: SvgPicture.asset(
                                      AppIcons.search_rounded,
                                      width: AppSpacing.spaceLg,
                                      height: AppSpacing.spaceLg,
                                      colorFilter: ColorFilter.mode(
                                        colors.onSurfaceVariant,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    suffixIcon: state.query.isEmpty
                                        ? null
                                        : IconButton(
                                            tooltip: 'Clear search',
                                            onPressed: () {
                                              _searchController.clear();
                                              search('');
                                            },
                                            icon: SvgPicture.asset(
                                              AppIcons.close_rounded,
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (state.status == ChooseCountryStatus.initial ||
                          state.status == ChooseCountryStatus.loading)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(AppSpacing.spaceLg),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        )
                      else if (state.status == ChooseCountryStatus.failure)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.spaceLg,
                            ),
                            child: AppStateMessage(
                              icon: AppIcons.location_on_outlined,
                              title: 'Unable to load countries',
                              message: state.message ?? 'Please try again.',
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      context.read<ChooseCountryCubit>().load(
                                        initialCountry: widget.initialCountry,
                                      ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (state.filteredCountries.isEmpty)
                        const SliverToBoxAdapter(
                          child: AppStateMessage(
                            icon: AppIcons.search_off_rounded,
                            title: 'No countries found',
                            message:
                                'Try another country name, code, or currency.',
                          ),
                        )
                      else
                        SliverList.builder(
                          itemCount: state.filteredCountries.length,
                          itemBuilder: (context, index) {
                            final country = state.filteredCountries[index];
                            final isSelected =
                                country.code == state.selectedCountry?.code;
                            return ListTile(
                              key: ValueKey('country-${country.code}'),
                              selected: isSelected,
                              selectedColor: colors.primary,
                              leading: ExcludeSemantics(
                                child: Text(
                                  country.flag,
                                  style: theme.textTheme.headlineMedium,
                                ),
                              ),
                              horizontalTitleGap: AppSpacing.spaceMd,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.spaceLg,
                                vertical: AppSpacing.spaceXs,
                              ),
                              title: Text(
                                country.name,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? colors.primary
                                      : colors.onSurface,
                                ),
                              ),
                              trailing: switch (country.defaultCurrencyCode) {
                                final currency? => Text(
                                  currency,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                                null => null,
                              },
                              onTap: () => Navigator.of(context).pop(country),
                            );
                          },
                        ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacing.spaceLg),
                      ),
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }
}
