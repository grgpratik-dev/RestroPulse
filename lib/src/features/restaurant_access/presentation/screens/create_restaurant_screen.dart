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
import 'package:restropulse/src/features/restaurant_access/presentation/widgets/restaurant_access_app_bar.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/widgets/restaurant_logo_selector.dart';

class CreateRestaurantScreen extends StatelessWidget {
  const CreateRestaurantScreen({this.onCreated, super.key});

  final VoidCallback? onCreated;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ImagePickerBloc>(),
      child: _CreateRestaurantForm(onCreated: onCreated),
    );
  }
}

class _CreateRestaurantForm extends StatefulWidget {
  const _CreateRestaurantForm({this.onCreated});

  final VoidCallback? onCreated;

  @override
  State<_CreateRestaurantForm> createState() => _CreateRestaurantFormState();
}

class _CreateRestaurantFormState extends State<_CreateRestaurantForm> {
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

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: const RestaurantAccessAppBar(showBackButton: true),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                            borderRadius: BorderRadius.circular(AppRadius.full),
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
                        onTap: () => showAppImagePickerBottomSheet(
                          context,
                          title: 'Add restaurant logo',
                          maxWidth: 1200,
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
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        hintText: "Business phone number (optional)",
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
                        'Currency',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spaceXs),
                      AppTextFormField(
                        initialValue: 'NPR (Rs)',
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
                      const SizedBox(height: AppSpacing.spaceXl),
                      SizedBox(
                        height: 54,
                        child: FilledButton(
                          key: const ValueKey('create-restaurant-button'),
                          onPressed: _createRestaurant,
                          child: const Text('Create restaurant'),
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
    );
  }

  void _createRestaurant() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.onCreated != null) {
      widget.onCreated!();
      return;
    }
    context.goNamed(AppRoute.dashboard.name);
  }
}
