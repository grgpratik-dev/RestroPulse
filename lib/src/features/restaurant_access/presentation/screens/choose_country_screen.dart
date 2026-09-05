import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_button.dart';

import '../../domain/entities/country.dart';
import '../cubits/choose_country/choose_country_cubit.dart';
import '../cubits/choose_country/choose_country_state.dart';
import '../widgets/country_picker_sheet.dart';

class ChooseCountryScreen extends StatelessWidget {
  const ChooseCountryScreen({
    this.initialCountry,
    this.onContinue,
    this.onUseAnotherGoogleAccount,
    super.key,
  });

  final String? initialCountry;
  final VoidCallback? onUseAnotherGoogleAccount;
  final void Function(String countryName)? onContinue;

  @override
  Widget build(BuildContext context) {
    return _ChooseCountryView(
      initialCountry: initialCountry,
      onContinue: onContinue,
    );
  }
}

class _ChooseCountryView extends StatelessWidget {
  const _ChooseCountryView({this.initialCountry, this.onContinue});
  final String? initialCountry;
  final void Function(String countryName)? onContinue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseCountryCubit, ChooseCountryState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final selectedCountry = state.selectedCountry;
        final country = selectedCountry;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(backgroundColor: AppColors.background),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.spaceMd),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spaceMd,
                      ),
                      child: Column(
                        children: [
                          const Spacer(),
                          SvgPicture.asset(
                            AppIcons.location_on_outlined,
                            width: 58,
                            height: 58,
                            colorFilter: const ColorFilter.mode(
                              AppColors.ink,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spaceXl),
                          Text(
                            'Choose Your Country',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spaceXs),
                          Text(
                            'Please select your country to help us give you a better experience.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.neutral600,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spaceXl),
                          _CountrySelector(
                            selectedCountry: selectedCountry,
                            onTap: () => _selectCountry(context),
                          ),
                          const Spacer(flex: 3),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: AppButton(
                              key: const ValueKey('continue-country-button'),
                              label: "Go ahead",
                              onPressed: country == null
                                  ? null
                                  : () {
                                      if (onContinue != null) {
                                        onContinue!(country.name);
                                      } else {
                                        context.pushNamed(
                                          AppRoute.createRestaurant.name,
                                          extra: country,
                                        );
                                      }
                                    },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spaceMd),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectCountry(BuildContext context) async {
    final cubit = context.read<ChooseCountryCubit>();
    cubit.search('');
    final selectedCountry = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CountryPickerSheet(initialCountry: initialCountry),
      ),
    );
    if (!context.mounted || selectedCountry == null) return;
    cubit.select(selectedCountry);
  }
}

class _CountrySelector extends StatelessWidget {
  const _CountrySelector({required this.selectedCountry, required this.onTap});

  final Country? selectedCountry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        key: const ValueKey('country-selector'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceMd,
            vertical: AppSpacing.spaceMd,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.neutral300),
          ),
          child: Row(
            children: [
              if (selectedCountry case final country?) ...[
                ExcludeSemantics(
                  child: Text(
                    country.flag,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceSm),
              ],
              Expanded(
                child: Text(
                  selectedCountry?.name ?? 'Select Country',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selectedCountry == null
                        ? AppColors.neutral600
                        : AppColors.ink,
                    fontWeight: selectedCountry == null
                        ? FontWeight.w400
                        : FontWeight.w600,
                  ),
                ),
              ),
              SvgPicture.asset(
                AppIcons.chevron_right_rounded,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.neutral600,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
