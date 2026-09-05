import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/di/dependency_injection.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/core/bloc/image_picker/image_picker_bloc.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_image_picker_bottom_sheet.dart';
import 'package:restropulse/src/core/widgets/app_text_form_field.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/widgets/restaurant_logo_selector.dart';

import '../../domain/entities/country.dart';
import '../cubits/create_restaurant/create_restaurant_cubit.dart';

class CreateRestaurantScreen extends StatelessWidget {
  const CreateRestaurantScreen({
    this.country = _defaultCountry,
    this.onCreated,
    super.key,
  });

  final Country country;

  static const _defaultCountry = Country(
    code: 'NP',
    name: 'Nepal',
    flag: '🇳🇵',
    currencyCodes: ['NPR'],
    defaultCurrencyCode: 'NPR',
  );

  final VoidCallback? onCreated;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ImagePickerBloc>()),
        BlocProvider(create: (_) => sl<CreateRestaurantCubit>()),
      ],
      child: _CreateRestaurantForm(country: country, onCreated: onCreated),
    );
  }
}

class _CreateRestaurantForm extends StatefulWidget {
  const _CreateRestaurantForm({required this.country, this.onCreated});

  final Country country;

  final VoidCallback? onCreated;

  @override
  State<_CreateRestaurantForm> createState() => _CreateRestaurantFormState();
}

class _CreateRestaurantFormState extends State<_CreateRestaurantForm> {
  Uint8List? _logo;
  bool _readingLogo = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ImagePickerBloc, ImagePickerState>(
      listener: (context, state) async {
        if (state.status != ImagePickerStatus.success || state.image == null) {
          return;
        }
        setState(() => _readingLogo = true);
        try {
          final source = await state.image!.readAsBytes();
          final codec = await ui.instantiateImageCodec(source);
          final frame = await codec.getNextFrame();
          codec.dispose();
          final recorder = ui.PictureRecorder();
          final canvas = Canvas(recorder);
          paintImage(
            canvas: canvas,
            rect: const Rect.fromLTWH(0, 0, 256, 256),
            image: frame.image,
            fit: BoxFit.contain,
          );
          final picture = recorder.endRecording();
          final thumbnail = await picture.toImage(256, 256);
          final data = await thumbnail.toByteData(
            format: ui.ImageByteFormat.png,
          );
          frame.image.dispose();
          picture.dispose();
          thumbnail.dispose();
          if (data == null) throw const FormatException('Invalid image');
          final bytes = data.buffer.asUint8List();
          if (mounted) setState(() => _logo = bytes);
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Could not read the selected image. Please try another.',
                ),
              ),
            );
          }
        } finally {
          if (mounted) setState(() => _readingLogo = false);
        }
      },
      child: BlocConsumer<CreateRestaurantCubit, CreateRestaurantState>(
        listener: (context, state) {
          if (state.success) {
            if (widget.onCreated != null) {
              widget.onCreated!();
            } else {
              context.goNamed(AppRoute.dashboard.name);
            }
          }
        },
        builder: (context, state) => PopScope(
          canPop: !state.loading,
          child: Scaffold(
            backgroundColor: AppColors.authBackground,
            appBar: AppBar(),
            body: SafeArea(
              top: false,
              child: Form(
                key: _formKey,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.spaceMd),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.spaceSm,
                                  vertical: AppSpacing.spaceXs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.mintChip,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.full,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.verified_user_outlined,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.primary,
                                        BlendMode.srcIn,
                                      ),
                                      width: 18,
                                      height: 18,
                                    ),
                                    const SizedBox(width: AppSpacing.spaceXs),
                                    const Text(
                                      'Owner setup',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceMd),
                            Text(
                              'Create your restaurant',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceXs),
                            Text(
                              'Add the basics now. You can complete the restaurant profile later.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.neutral700,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceLg),
                            RestaurantLogoSelector(
                              imageBytes: _logo,
                              onTap: state.loading || _readingLogo
                                  ? null
                                  : () => showAppImagePickerBottomSheet(
                                      context,
                                      title: 'Add restaurant logo',
                                      maxWidth: 512,
                                      maxHeight: 512,
                                      imageQuality: 85,
                                    ),
                            ),
                            const SizedBox(height: AppSpacing.spaceLg),
                            Text(
                              'Restaurant name',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceXs),
                            AppTextFormField(
                              key: const ValueKey('restaurant-name-field'),
                              enabled:
                                  !state.loading && state.restaurantId == null,
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              hintText: "Enter your restaurant name",
                              prefixIcon: SvgPicture.asset(
                                AppIcons.storefront_outlined,
                                width: 22,
                                height: 22,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter your restaurant name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.spaceMd),
                            Text(
                              'Address',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceXs),
                            AppTextFormField(
                              key: const ValueKey('restaurant-location-field'),
                              enabled:
                                  !state.loading && state.restaurantId == null,
                              controller: _addressController,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.done,
                              hintText: "Enter the restaurant location",
                              prefixIcon: SvgPicture.asset(
                                AppIcons.location_on_outlined,
                                width: 22,
                                height: 22,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter the restaurant location';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppSpacing.spaceMd),
                            Text(
                              'Phone number',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceXs),
                            AppTextFormField(
                              controller: _phoneController,
                              enabled:
                                  !state.loading && state.restaurantId == null,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.done,
                              hintText: 'Business phone number (optional)',
                            ),
                            const SizedBox(height: AppSpacing.spaceMd),
                            Text(
                              'Currency',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spaceXs),
                            AppTextFormField(
                              initialValue:
                                  widget.country.defaultCurrencyCode ??
                                  widget.country.currencyCodes.firstOrNull ??
                                  '',
                              readOnly: true,
                              prefixIcon: SvgPicture.asset(
                                AppIcons.currency,
                                width: 22,
                                height: 22,
                              ),
                              suffixIcon: SvgPicture.asset(
                                AppIcons.lock_outline_rounded,
                                width: 20,
                                height: 20,
                              ),
                            ),
                            if (state.message != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: AppSpacing.spaceMd,
                                ),
                                child: Text(state.message!),
                              ),
                            if (state.restaurantId != null && !state.loading)
                              TextButton(
                                onPressed: context
                                    .read<CreateRestaurantCubit>()
                                    .continueWithoutLogo,
                                child: const Text('Continue without logo'),
                              ),
                            const SizedBox(height: AppSpacing.spaceXl),
                            SizedBox(
                              height: 54,
                              child: FilledButton(
                                key: const ValueKey('create-restaurant-button'),
                                onPressed: state.loading || _readingLogo
                                    ? null
                                    : _createRestaurant,
                                child: Text(
                                  state.loading
                                      ? 'Saving…'
                                      : state.restaurantId != null
                                      ? 'Retry logo upload'
                                      : 'Create restaurant',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createRestaurant() {
    if (!_formKey.currentState!.validate()) return;

    context.read<CreateRestaurantCubit>().submit(
      country: widget.country,
      name: _nameController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      logo: _logo,
    );
  }
}
