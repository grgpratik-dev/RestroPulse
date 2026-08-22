import 'package:flutter/material.dart';
import 'package:restropulse/src/core/widgets/app_text_form_field.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../widgets/profile_form_widgets.dart';

class EditRestaurantScreen extends StatefulWidget {
  const EditRestaurantScreen({this.onSaved, super.key});

  final VoidCallback? onSaved;

  @override
  State<EditRestaurantScreen> createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Boys to Serve');
    _phoneController = TextEditingController(text: '+977 9800000000');
    _emailController = TextEditingController(text: 'hello@boystoserve.com');
    _addressController = TextEditingController(text: 'Lakeside Road');
    _cityController = TextEditingController(text: 'Pokhara, Nepal');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Edit Restaurant',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.spaceMd,
              AppSpacing.spaceSm,
              AppSpacing.spaceMd,
              AppSpacing.space2xl,
            ),
            children: [
              ProfileImageEditor(
                label: 'Change restaurant logo',
                isRestaurant: true,
                onTap: () => showProfileImageOptions(
                  context,
                  title: 'Change restaurant logo',
                ),
              ),
              const SizedBox(height: AppSpacing.spaceXl),
              ProfileFormSection(
                title: 'Restaurant details',
                description:
                    'This information identifies the restaurant throughout RestroPulse.',
                children: [
                  AppTextFormField(
                    key: const ValueKey('edit-restaurant-name-field'),
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.organizationName],

                    validator: _required('Enter the restaurant name'),
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  AppTextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.telephoneNumber],

                    validator: _required('Enter the business phone number'),
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  AppTextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],

                    validator: _emailValidator,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceXl),
              ProfileFormSection(
                title: 'Location',
                description:
                    'Used to identify this restaurant to members and viewers.',
                children: [
                  AppTextFormField(
                    controller: _addressController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,

                    validator: _required('Enter the restaurant address'),
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  AppTextFormField(
                    key: const ValueKey('edit-restaurant-location-field'),
                    controller: _cityController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,

                    validator: _required('Enter the city and country'),
                    onFieldSubmitted: (_) => _save(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceXl),
              SizedBox(
                height: 52,
                child: FilledButton(
                  key: const ValueKey('save-restaurant-button'),
                  onPressed: _save,
                  child: const Text('Save restaurant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FormFieldValidator<String> _required(String message) => (value) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  };

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter the business email';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSaved?.call();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Restaurant details updated.')),
      );
  }
}
