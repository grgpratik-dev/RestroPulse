import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/widgets/app_password_widgets.dart';
import '../../widgets/profile_form_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({this.onPasswordChanged, super.key});

  final VoidCallback? onPasswordChanged;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmationController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirmation = true;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_refreshRequirements);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_refreshRequirements);
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Change Password',
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
              ProfileFormSection(
                title: 'Secure your account',
                description:
                    'Enter your current password before choosing a new one.',
                children: [
                  AppPasswordField(
                    fieldKey: const ValueKey('current-password-field'),
                    controller: _currentPasswordController,
                    label: 'Current password',
                    obscureText: _obscureCurrent,
                    autofillHints: const [AutofillHints.password],
                    onVisibilityChanged: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.spaceLg),
                  AppPasswordField(
                    fieldKey: const ValueKey('new-password-field'),
                    controller: _newPasswordController,
                    label: 'New password',
                    obscureText: _obscureNew,
                    autofillHints: const [AutofillHints.newPassword],
                    onVisibilityChanged: () =>
                        setState(() => _obscureNew = !_obscureNew),
                    validator: _validateNewPassword,
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  AppPasswordRequirements(
                    password: _newPasswordController.text,
                  ),
                  const SizedBox(height: AppSpacing.spaceLg),
                  AppPasswordField(
                    fieldKey: const ValueKey('confirm-new-password-field'),
                    controller: _confirmationController,
                    label: 'Confirm new password',
                    obscureText: _obscureConfirmation,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    onVisibilityChanged: () => setState(
                      () => _obscureConfirmation = !_obscureConfirmation,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _changePassword(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceXl),
              SizedBox(
                height: 52,
                child: FilledButton(
                  key: const ValueKey('change-password-submit-button'),
                  onPressed: _changePassword,
                  child: const Text('Update password'),
                ),
              ),
              const SizedBox(height: AppSpacing.spaceSm),
              Text(
                'You’ll continue using your email address and new password to sign in.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.neutral600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateNewPassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Enter a new password';
    if (!AppPasswordRequirements.isValid(password)) {
      return 'Use at least 8 characters with a letter and number';
    }
    if (password == _currentPasswordController.text) {
      return 'Choose a password different from your current one';
    }
    return null;
  }

  void _refreshRequirements() => setState(() {});

  void _changePassword() {
    if (!_formKey.currentState!.validate()) return;
    widget.onPasswordChanged?.call();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Password updated.')));
  }
}
