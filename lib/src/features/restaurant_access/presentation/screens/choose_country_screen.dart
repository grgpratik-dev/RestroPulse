import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class ChooseCountryScreen extends StatefulWidget {
  const ChooseCountryScreen({
    this.initialCountry,
    this.onContinue,
    this.onUseAnotherGoogleAccount,
    super.key,
  });

  final String? initialCountry;
  final ValueChanged<String>? onContinue;
  final VoidCallback? onUseAnotherGoogleAccount;

  @override
  State<ChooseCountryScreen> createState() => _ChooseCountryScreenState();
}

class _ChooseCountryScreenState extends State<ChooseCountryScreen> {
  static const _countries = <String>[
    'Australia',
    'Austria',
    'Bangladesh',
    'Bhutan',
    'Brazil',
    'Canada',
    'China',
    'Denmark',
    'Egypt',
    'France',
    'Germany',
    'India',
    'Indonesia',
    'Italy',
    'Japan',
    'Malaysia',
    'Maldives',
    'Mexico',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Norway',
    'Pakistan',
    'Philippines',
    'Portugal',
    'Qatar',
    'Saudi Arabia',
    'Singapore',
    'South Africa',
    'South Korea',
    'Spain',
    'Sri Lanka',
    'Sweden',
    'Switzerland',
    'Thailand',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Vietnam',
  ];

  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.spaceMd),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.spaceLg,
                    AppSpacing.space2xl,
                    AppSpacing.spaceLg,
                    AppSpacing.spaceLg,
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
                        selectedCountry: _selectedCountry,
                        onTap: _selectCountry,
                      ),
                      const Spacer(flex: 3),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          key: const ValueKey('continue-country-button'),
                          onPressed: _selectedCountry == null
                              ? null
                              : () =>
                                    widget.onContinue?.call(_selectedCountry!),
                          child: const Text('Go ahead'),
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
  }

  Future<void> _selectCountry() async {
    final selectedCountry = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.35,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spaceLg,
                AppSpacing.spaceXs,
                AppSpacing.spaceLg,
                AppSpacing.spaceSm,
              ),
              child: Text(
                'Select country',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.only(bottom: AppSpacing.spaceLg),
                itemCount: _countries.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final country = _countries[index];
                  final isSelected = country == _selectedCountry;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spaceLg,
                    ),
                    title: Text(country),
                    trailing: isSelected
                        ? SvgPicture.asset(
                            AppIcons.check_rounded,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          )
                        : null,
                    onTap: () => Navigator.of(context).pop(country),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (!mounted || selectedCountry == null) return;
    setState(() => _selectedCountry = selectedCountry);
  }
}

class _CountrySelector extends StatelessWidget {
  const _CountrySelector({required this.selectedCountry, required this.onTap});

  final String? selectedCountry;
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
              Expanded(
                child: Text(
                  selectedCountry ?? 'Select Country',
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
