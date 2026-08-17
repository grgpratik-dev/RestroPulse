import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restropulse/src/app/router/app_route.dart';
import 'package:restropulse/src/app/theme/app_colors.dart';
import 'package:restropulse/src/app/theme/app_radius.dart';
import 'package:restropulse/src/app/theme/app_spacing.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/widgets/restaurant_access_app_bar.dart';
import 'package:restropulse/src/features/restaurant_access/presentation/widgets/restaurant_logo_selector.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';
import 'package:restropulse/src/core/widgets/app_icon.dart';

class CreateRestaurantScreen extends StatefulWidget {
  const CreateRestaurantScreen({this.onCreated, super.key});

  final VoidCallback? onCreated;

  @override
  State<CreateRestaurantScreen> createState() => _CreateRestaurantScreenState();
}

class _CreateRestaurantScreenState extends State<CreateRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
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
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.spaceLg,
              AppSpacing.spaceMd,
              AppSpacing.spaceLg,
              AppSpacing.space2xl,
            ),
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
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppIcon(
                                AppIcons.verified_user_outlined,
                                color: AppColors.primary,
                                size: 17,
                              ),
                              SizedBox(width: AppSpacing.spaceXs),
                              Text(
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
                        key: const ValueKey('restaurant-logo-selector'),
                        onTap: () => _showLogoOptions(context),
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
                      TextFormField(
                        key: const ValueKey('restaurant-name-field'),
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.organizationName],
                        decoration: const InputDecoration(
                          hintText: 'e.g. Boys to Serve',
                          prefixIcon: AppIcon(AppIcons.storefront_outlined),
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
                        'Location',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spaceXs),
                      TextFormField(
                        key: const ValueKey('restaurant-location-field'),
                        controller: _locationController,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Pokhara, Nepal',
                          prefixIcon: AppIcon(AppIcons.location_on_outlined),
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
                      TextFormField(
                        initialValue: 'NPR (Rs)',
                        readOnly: true,
                        decoration: const InputDecoration(
                          prefixIcon: AppIcon(AppIcons.currency),
                          suffixIcon: AppIcon(
                            AppIcons.lock_outline_rounded,
                            size: 19,
                          ),
                          helperText:
                              'More currencies can be added from settings later.',
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

  Future<void> _showLogoOptions(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.spaceLg,
            AppSpacing.spaceXs,
            AppSpacing.spaceLg,
            AppSpacing.spaceLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add restaurant logo',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.spaceSm),
              ListTile(
                leading: const AppIcon(AppIcons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () => Navigator.of(sheetContext).pop(),
              ),
              ListTile(
                leading: const AppIcon(AppIcons.camera_alt_outlined),
                title: const Text('Take a photo'),
                onTap: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
