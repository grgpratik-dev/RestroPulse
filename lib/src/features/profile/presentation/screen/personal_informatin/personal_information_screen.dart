import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restropulse/src/app/di/dependency_injection.dart';
import 'package:restropulse/src/core/bloc/image_picker/image_picker_bloc.dart';
import 'package:restropulse/src/core/widgets/app_image_picker_bottom_sheet.dart';
import 'package:restropulse/src/core/widgets/app_text_form_field.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../widgets/profile_form_widgets.dart';
import 'package:restropulse/src/core/icons/app_icons.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({this.onSaved, super.key});

  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ImagePickerBloc>(),
      child: _PersonalInformationForm(onSaved: onSaved),
    );
  }
}

class _PersonalInformationForm extends StatefulWidget {
  const _PersonalInformationForm({this.onSaved});

  final VoidCallback? onSaved;

  @override
  State<_PersonalInformationForm> createState() =>
      _PersonalInformationFormState();
}

class _PersonalInformationFormState extends State<_PersonalInformationForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Pratik Gurung');
    _emailController = TextEditingController(text: 'pratik@example.com');
    _phoneController = TextEditingController(text: '+977 9800000000');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Personal Information',
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
                label: 'Change profile photo',
                onTap: () => showAppImagePickerBottomSheet(
                  context,
                  title: 'Change profile photo',
                  maxWidth: 1200,
                  imageQuality: 85,
                ),
              ),
              const SizedBox(height: AppSpacing.spaceXl),
              ProfileFormSection(
                title: 'Account holder',
                description:
                    'Your personal details are separate from the restaurant profile.',
                children: [
                  AppTextFormField(
                    key: const ValueKey('personal-name-field'),
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    validator: _required('Enter your full name'),
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  AppTextFormField(
                    key: const ValueKey('personal-email-field'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: AppSpacing.spaceMd),
                  AppTextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.telephoneNumber],
              
                    validator: _required('Enter your phone number'),
                    onFieldSubmitted: (_) => _save(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceXl),
              ProfileFormSection(
                title: 'Restaurant access',
                description:
                    'Access is managed by the restaurant owner from Members & Access.',
                children: [
                  AppTextFormField(
                    initialValue: 'Owner · Boys to Serve',
                    readOnly: true,
                   suffixIcon: SvgPicture.asset(
                        AppIcons.lock_outline_rounded,
                        width: 20,
                        height: 20,
                      ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceXl),
              SizedBox(
                height: 52,
                child: FilledButton(
                  key: const ValueKey('save-personal-information-button'),
                  onPressed: _save,
                  child: const Text('Save personal information'),
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
    if (email.isEmpty) return 'Enter your email address';
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
        const SnackBar(content: Text('Personal information updated.')),
      );
  }
}
